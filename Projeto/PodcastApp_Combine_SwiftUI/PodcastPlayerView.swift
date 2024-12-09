import SwiftUI
import AVKit

struct PodcastPlayerView: View {
    var episodeTitle: String
    var audioURL: URL
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text(episodeTitle)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            if player != nil {
                // Progress Slider
                Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                    if !editing {
                        player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))
                    }
                }
                .padding()
                
                // Time labels
                HStack {
                    Text(formatTime(currentTime))
                    Spacer()
                    Text(formatTime(duration))
                }
                .font(.caption)
                .padding(.horizontal)
                
                // Playback controls
                HStack(spacing: 40) {
                    Button(action: {
                        seek(by: -15)
                    }) {
                        Image(systemName: "gobackward.15")
                            .font(.title)
                    }
                    
                    Button(action: togglePlayback) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                    }
                    
                    Button(action: {
                        seek(by: 15)
                    }) {
                        Image(systemName: "goforward.15")
                            .font(.title)
                    }
                }
                .padding()
            } else {
                ProgressView()
                    .padding()
            }
            
            Spacer()
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        print("Setting up player with URL: \(audioURL.absoluteString)")
        
        // Create an AVPlayerItem first to handle errors
        let playerItem = AVPlayerItem(url: audioURL)
        
        // Observe the status of the player item
        NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime, object: playerItem, queue: .main) { notification in
            if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
                self.errorMessage = "Error playing audio: \(error.localizedDescription)"
                print("Playback error: \(error)")
            }
        }
        
        // Create the player with the item
        player = AVPlayer(playerItem: playerItem)
        
        // Add time observer
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { time in
            currentTime = time.seconds
        }
        
        // Observe the duration
        if let currentItem = player?.currentItem {
            currentItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
                DispatchQueue.main.async {
                    if currentItem.status == .readyToPlay {
                        self.duration = CMTimeGetSeconds(currentItem.asset.duration)
                    }
                }
            }
        }
    }
    
    private func togglePlayback() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    private func seek(by seconds: Double) {
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + seconds
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
    }
    
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
