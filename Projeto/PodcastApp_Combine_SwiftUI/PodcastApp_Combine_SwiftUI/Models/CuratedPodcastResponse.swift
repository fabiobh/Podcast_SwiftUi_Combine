//
//  CuratedPodcastResponse.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 24/12/24.
//

struct CuratedPodcastResponse: Codable {
    let curated_lists: [CuratedList]
}

struct CuratedList: Codable {
    let id: String
    let title: String
    let podcasts: [Podcast]
}
