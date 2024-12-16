import SwiftUI
import AVFoundation

struct PodcastPlayerView: View {
    var episodeTitle: String
    var audioURL: URL
    
    @State private var isPlaying = false
    @State private var playbackTime: TimeInterval = 0
    @State private var showAlert = false
    
    @StateObject private var playerManager = PlayerManager()
    
    var body: some View {
        VStack {
            
            Text(episodeTitle)
                .font(.largeTitle)
                .padding()
            
            Slider(value: $playbackTime, in: 0...((playerManager.player?.currentItem?.duration.seconds ?? 0.0) > 0 ? playerManager.player?.currentItem?.duration.seconds ?? 0.0 : 1.0), onEditingChanged: { editing in
                if !editing {
                    playerManager.seek(to: CMTime(seconds: playbackTime, preferredTimescale: 600))
                }
            })
            .padding()
            
            Text(formatTime(playbackTime))
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: {
                    playerManager.seek(by: -10)
                }) {
                    Image("button_backward")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: { togglePlayback() }) {
                    Image(isPlaying ? "button_pause" : "button_play")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    playerManager.seek(by: 10)
                }) {
                    Image("button_forward")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .onAppear {
            playerManager.setupPlayer(with: audioURL)
            setupTimeObserver()
        }
        .onDisappear {
            playerManager.removeTimeObserver()
        }
    }
    
    private func setupTimeObserver() {
        playerManager.addPeriodicTimeObserver { time in
            playbackTime = time
        }
    }
    
    private func togglePlayback() {
        if isPlaying {
            playerManager.pause()
        } else {
            playerManager.play()
        }
        isPlaying.toggle()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

class PlayerManager: ObservableObject {
    static let shared = PlayerManager()
    var player: AVPlayer?
    private var timeObserverToken: Any?
    
    func setupPlayer(with url: URL) {
        if player == nil || player?.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
            player = AVPlayer(url: url)
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
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
            callback(time.seconds)
        }
    }
    
    func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
