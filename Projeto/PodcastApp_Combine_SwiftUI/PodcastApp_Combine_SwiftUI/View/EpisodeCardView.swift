//
//  EpisodeCardView.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 09/12/24.
//
import SwiftUI

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
