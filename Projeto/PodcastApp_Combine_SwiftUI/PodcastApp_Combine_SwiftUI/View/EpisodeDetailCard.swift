//
//  EpisodeDetailCard.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 09/12/24.
//
import SwiftUI
import Combine

struct EpisodeDetailCard: View {
    let episode: PodcastEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            AsyncImage(url: URL(string: episode.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(episode.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(episode.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                HStack {
                    Text(formatDate(episode.publishedAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDuration(episode.duration))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }
}
