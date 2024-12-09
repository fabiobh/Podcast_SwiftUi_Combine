//
//  ContentView.swift
//  Podcast_SwiftUi_Combine
//
//  Created by FabioCunha on 07/12/24.
//

import SwiftUI
import Combine
import AVKit
import AVFoundation

struct ContentView: View {
    @StateObject private var podcastService = PodcastService()
    @State private var player: AVPlayer?
    
    //devkey
    //eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZGFmZDU3Yi0wM2U2LTQ5YmYtYjE3Ni0yMjk5YzllYjM2MDciLCJqdGkiOiIxOWIyM2M2ZDFlNGE5ZTY5M2ZlNmZhYjIzZmY3ZmJiODk0MjgxZTY5YWZkNDZhZTY1NzM1MTk4YTI2ZmI1OGNiNTQ0OTcwMGMyMDM4NGI2ZSIsImlhdCI6MTczMzc4NTI2Ny4xMjc4NjYsIm5iZiI6MTczMzc4NTI2Ny4xMjc4NjksImV4cCI6MTc2NTMyMTI2Ny4xMTQwMTUsInN1YiI6IiIsInNjb3BlcyI6WyIqIl19.sOmhlAJUdGfTNAuY27GFJXJnLoAx-fNSO5MnPYFY3l5DXJjzPi2xV-tWlCvjkT9pPiDkwpKz4x4xZmI_KfCWNsTQg3kq9VRReJe0GZT3QTs_mOeFSzM5rK6wdQM7z99n1LPbi-NO0ZbibJnAJUJ4JRr5ZHzOTXc9BFKhzDgXJKmv6U06vx4POmnYR8Gxod4BOyEa19lczj8CoVk-fc5sjKC7zfZHdBuzx_X5Ia5Z6mMM8nZPfFG_bR0BbyLPvi83rMJnGWfp3dAhaNa8AaAs4sK7l0vZEkWZLfqtThGUjgvuuiy0fgjybSjYAhzsnaDBBJ9DmGjhrdW0zeKe0JScDtTXUrmJBELwix4Ir1F8GpgYSUN7p5xNG6Aup3WwGnmx3BBEon-KgPwuC30B36_DIJtZaY4COp8HmUBNlu8kP-7fn-dMOkQqz89zzr71Xk3qdtD2ckRYFlwqtzYBjAbo5aslQ3EN1rg_jcLr3E1xRN2r99YHTSQ82CaE-IYwNtGO6JoNytvQsuqHikgkiVauQXPbFEhCR8GdXDU3y6uaxbtgKMzdF5akdq9CZcQwVKnuFItNOGdRjs-WuuFmLrRAUo3YUbKmtdVjbgoJ0DLeBWb7rDokin0Us7OZ1K3Vk7ydcAioswpVMAU0X0S50odM72X4hSM9hXuJKy7SYSeahQ4
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Top Bar
                    HStack {
                        // Title
                        Text("PodCaster")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                        //Image(systemName: "line.horizontal.3")
                    }
                    .padding()

                    // Navigation Bar
                    /*
                    HStack {
                        Text("Home")
                        Text("Busca")
                        Text("Biblioteca")
                    }
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    */

                    // Podcasts Section
                    Text("Best Podcasts")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(podcastService.podcasts) { podcast in
                                NavigationLink {
                                    PodcastDetailView(podcastId: podcast.id, podcastTitle: podcast.title)
                                } label: {
                                    PodcastCardView(imageUrl: podcast.imageUrl, title: podcast.title)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // New Episodes Section
                    Text("New Episodes")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        EpisodeCardView(imageName: "image_podcast1")
                        EpisodeCardView(imageName: "episode2")
                    }
                    
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 50) // Add padding to make room for the button
            .onAppear {
                podcastService.fetchPodcasts()
            }
            .overlay(
                VStack {
                    Spacer()
                    Button(action: {
                        openWebPage()
                    }) {
                        Text("Open Web Page")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(action: {
                        playAudio()
                    }) {
                        Text("Play Audio")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            )
        }
    }

    private func openWebPage() {
        if let url = URL(string: "https://audio.listennotes.com/e/p/dba194ab74264eceb2d476d93af26038/") {
            UIApplication.shared.open(url)
        }
    }

    private func playAudio() {
        if let url = URL(string: "https://traffic.megaphone.fm/GLT5025099642.mp3") {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}

#Preview {
    ContentView()
}
