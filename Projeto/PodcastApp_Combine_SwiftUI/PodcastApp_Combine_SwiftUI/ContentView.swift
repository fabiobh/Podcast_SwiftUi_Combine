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
        ScrollView {
            VStack(alignment: .leading) {
                // Top Bar
                HStack {
                    // Title
                    Text("Best PodCast")
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
                Text("Podcasts")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(podcastService.podcasts) { podcast in
                            PodcastCardView(imageUrl: podcast.imageUrl, title: podcast.title)
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

struct PodcastCardView: View {
    var imageUrl: String
    var title: String

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipped()
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            Text(title)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct EpisodeCardView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 100)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
