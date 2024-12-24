//
//  PlayerManager.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 24/12/24.
//
import Foundation
import AVFoundation
import Combine

class PlayerManager: ObservableObject {
    @Published var duration: TimeInterval = 0
    
    static let shared = PlayerManager()
    var player: AVPlayer?
    private var timeObserverToken: Any?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowAirPlay, .allowBluetooth]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
        
    func setupPlayer(with url: URL) {
            if player == nil || player?.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                
                // Setup duration observer
                playerItem.publisher(for: \.duration)
                    .map { duration -> TimeInterval in
                        let timeInterval = CMTimeGetSeconds(duration)
                        return timeInterval.isNaN ? 0 : timeInterval
                    }
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] newDuration in
                        self?.duration = newDuration
                    }
                    .store(in: &cancellables)
                    
                // Add audio interruption handling
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handleInterruption),
                    name: AVAudioSession.interruptionNotification,
                    object: nil
                )
            }
        }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                play()
            }
        @unknown default:
            break
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seek(to time: CMTime) {
        player?.seek(to: time)
    }
    
    func seek(by seconds: TimeInterval) {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTime(seconds: currentTime.seconds + seconds, preferredTimescale: 600)
        player?.seek(to: newTime)
    }
    
    func addPeriodicTimeObserver(callback: @escaping (TimeInterval) -> Void) {
        timeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            callback(time.seconds)
        }
    }
    
    func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        removeTimeObserver()
    }
}
