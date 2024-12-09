//
//  ContentView.swift
//  Podcast_SwiftUi_Combine
//
//  Created by FabioCunha on 07/12/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var podcastService = PodcastService()
    
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
                    Text("Novo episódios")
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
            .onAppear {
                podcastService.fetchPodcasts()
            }
        }
    }
}

#Preview {
    ContentView()
}
