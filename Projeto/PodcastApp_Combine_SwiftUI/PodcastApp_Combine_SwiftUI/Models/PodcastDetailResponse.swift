//
//  PodcastDetailResponse.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 08/12/24.
//


struct PodcastDetailResponse: Decodable {
    let episodes: [PodcastEpisode]
    
    enum CodingKeys: String, CodingKey {
        case episodes = "episodes"
    }
}