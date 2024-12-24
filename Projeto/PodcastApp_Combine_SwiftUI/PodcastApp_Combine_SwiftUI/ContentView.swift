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
    @State private var playbackTime: Double = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Top Bar
                    HStack {
                        // Title
                        Text("PodFy")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)
                        Spacer()
                        //Image(systemName: "magnifyingglass")
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
                    
                    Text("Curated Podcasts")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(podcastService.curatedPodcasts) { podcast in
                                                    NavigationLink {
                                                        PodcastDetailView(podcastId: podcast.id, podcastTitle: podcast.title)
                                                    } label: {
                                                        PodcastCardView(imageUrl: podcast.imageUrl, title: podcast.title)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }

                    /*
                    Text("New Episodes")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        EpisodeCardView(imageName: "image_podcast1")
                        EpisodeCardView(imageName: "episode2")
                    }
                    .padding(.horizontal)
                    */
                }
            }
            .padding(.bottom, 50)
            .onAppear {
                podcastService.fetchPodcasts()
                podcastService.fetchCuratedPodcasts()
            }
            
        }
    }

    private func openWebPage() {
        if let url = URL(string: "https://audio.listennotes.com/e/p/dba194ab74264eceb2d476d93af26038/") {
            UIApplication.shared.open(url)
        }
    }

    private func playAudio() {
        // https://audio.listennotes.com/e/p/dba194ab74264eceb2d476d93af26038
        // https://traffic.megaphone.fm/GLT5025099642.mp3
        if let url = URL(string: "https://audio.listennotes.com/e/p/dba194ab74264eceb2d476d93af26038/") {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}

#Preview {
    ContentView()
}
