//
//  ContentView.swift
//  Podcast_SwiftUi_Combine
//
//  Created by FabioCunha on 07/12/24.
//

import SwiftUI

struct ContentView: View {
    
    let apiKey = "6a98e80f4ba54b7cb7b8578fec57755a"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Top Bar
                HStack {
                    // Title
                    Text("PodCast")
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
                        PodcastCardView(imageName: "image_podcast1", title: "Podcast Recomendado")
                        PodcastCardView(imageName: "podcast2", title: "Lado B")
                        PodcastCardView(imageName: "image_podcast1", title: "Podcast Recomendado")
                        PodcastCardView(imageName: "image_podcast1", title: "Podcast Recomendado")
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
    }
}

struct PodcastCardView: View {
    var imageName: String
    var title: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
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
