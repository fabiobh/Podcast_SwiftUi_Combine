//
//  PodcastCardView.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 09/12/24.
//
import SwiftUI
import Combine

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
