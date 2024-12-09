import Foundation

enum APIConfig {
    private static let baseURL = "https://listen-api.listennotes.com/api/v2"
    static let apiKey = "6a98e80f4ba54b7cb7b8578fec57755a"
    
    enum Endpoints {
        case bestPodcasts
        case podcastDetails(id: String)
        
        var url: URL? {
            switch self {
            case .bestPodcasts:
                return URL(string: "\(APIConfig.baseURL)/best_podcasts")
            case .podcastDetails(let id):
                print("x: \(APIConfig.baseURL)/podcasts/\(id)?sort=recent_first")
                return URL(string: "\(APIConfig.baseURL)/podcasts/\(id)?sort=recent_first")
            }
        }
    }
    
    static func createRequest(for endpoint: Endpoints) -> URLRequest? {
        guard let url = endpoint.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-ListenAPI-Key")
        return request
    }
}
