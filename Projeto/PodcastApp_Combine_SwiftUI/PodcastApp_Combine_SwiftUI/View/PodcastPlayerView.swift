import SwiftUI
import AVFoundation

struct PodcastPlayerView: View {
    var episodeTitle: String
    var audioURL: URL
    
    // @State private var player: AVAudioPlayer?
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var playbackTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text(episodeTitle)
                .font(.largeTitle)
                .padding()
            
            Slider(value: $playbackTime, in: 0...((player?.currentItem?.duration.seconds ?? 0.0) > 0 ? player?.currentItem?.duration.seconds ?? 0.0 : 1.0), onEditingChanged: { editing in
                if !editing {
                    player?.seek(to: CMTime(seconds: playbackTime, preferredTimescale: 600))
                }
            })
            .padding()
            
            Text(formatTime(playbackTime))
                .font(.headline)
                //.padding()
                        
            HStack(spacing: 20) {
                Button(action: {
                    seek(by: -10)
                }) {
                    Text("<")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: { togglePlayback() }) {
                    Text(isPlaying ? "Pause" : "Play")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    seek(by: 10)
                }) {
                    Text(">")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .onAppear { setupPlayer() }
    }
    
    private func setupPlayer() {
        player = AVPlayer(url: audioURL)
        //player?.play()
                
        // Add a time observer to update playbackTime
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
            playbackTime = time.seconds
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
    
    private func seek(by seconds: TimeInterval) {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTime(seconds: currentTime.seconds + seconds, preferredTimescale: 600)
        player?.seek(to: newTime)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
