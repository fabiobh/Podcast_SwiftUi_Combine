import SwiftUI
import AVFoundation

struct PodcastPlayerView: View {
    var episodeTitle: String
    var audioURL: URL
    
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var playbackTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text(episodeTitle)
                .font(.largeTitle)
                .padding()
            
            Slider(value: $playbackTime, in: 0...(player?.duration ?? 0), onEditingChanged: { editing in
                if !editing {
                    player?.currentTime = playbackTime
                }
            })
            .padding()
            
            HStack {
                Button(action: { togglePlayback() }) {
                    Text(isPlaying ? "Pause" : "Play")
                }
            }
            .padding()
        }
        .onAppear { setupPlayer() }
    }
    
    private func setupPlayer() {
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.prepareToPlay()
        } catch {
            print("Error initializing player: \(error)")
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
}
