import Foundation

struct Podcast: Codable, Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl = "image"
    }
}
