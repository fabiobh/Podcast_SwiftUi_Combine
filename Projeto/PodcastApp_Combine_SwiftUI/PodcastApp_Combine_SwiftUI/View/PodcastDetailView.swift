//
//  PodcastDetailView.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 08/12/24.
//
import SwiftUI
import Combine

struct PodcastDetailView: View {
    let podcastId: String
    let podcastTitle: String
    @StateObject private var viewModel = PodcastDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(podcastTitle)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                ForEach(viewModel.episodes) { episode in
                    EpisodeDetailCard(episode: episode)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchEpisodes(podcastId: podcastId)
        }
    }
}
