//
//  PodcastEpisode.swift
//  PodcastApp_Combine_SwiftUI
//
//  Created by FabioCunha on 08/12/24.
//


struct PodcastEpisode: Identifiable, Decodable {
    let id: String
    let title: String
    let description: String
    let audio: String
    let image: String
    let publishedAt: Int64
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case audio = "audio"
        case image = "thumbnail"
        case publishedAt = "pub_date_ms"
        case duration = "audio_length_sec"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        let rawDescription = try container.decode(String.self, forKey: .description)
        description = rawDescription.removeHTMLTags()
        audio = try container.decode(String.self, forKey: .audio)
        image = try container.decode(String.self, forKey: .image)
        publishedAt = try container.decode(Int64.self, forKey: .publishedAt)
        duration = try container.decode(Int.self, forKey: .duration)
    }
}