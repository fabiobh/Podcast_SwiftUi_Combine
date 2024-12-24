import SwiftUI
import Combine
import AVFoundation

struct PodcastPlayerView: View {
    var episodeTitle: String
    var audioURL: URL
    
    public init(episodeTitle: String, audioURL: URL) {
        self.episodeTitle = episodeTitle
        self.audioURL = audioURL
    }
    
    @State private var isPlaying = false
    @State private var playbackTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @State private var showAlert = false
    @State private var isEditing = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @StateObject private var playerManager = PlayerManager()
    
    var body: some View {
        VStack {
            Text(episodeTitle)
                .font(.largeTitle)
                .padding()
            /*
            Slider(
                value: $playbackTime,
                in: 0...max(duration, 1),
                onEditingChanged: { editing in
                    if !editing {
                        playerManager.seek(to: CMTime(seconds: playbackTime, preferredTimescale: 600))
                    }
                }
            )
            .padding()
            */
            
            Slider(
                value: Binding(
                    get: { Double(playbackTime) },
                    set: { newValue in
                        playbackTime = TimeInterval(newValue)
                        if !isEditing {
                            playerManager.seek(to: CMTime(seconds: newValue, preferredTimescale: 600))
                        }
                    }
                ),
                in: 0...Double(max(playerManager.duration, 1))
            ) { editing in
                isEditing = editing
            }
            
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
            // setupDurationObserver()
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
    
    /*
    private mutating func setupDurationObserver() {
        playerManager.player?.currentItem?.publisher(for: \.duration)
            .map { duration -> TimeInterval in
                let timeInterval = CMTimeGetSeconds(duration)
                return timeInterval.isNaN ? 0 : timeInterval
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDuration in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.duration = newDuration
                }
            }
            .store(in: &cancellables)
    }
    */
    
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
