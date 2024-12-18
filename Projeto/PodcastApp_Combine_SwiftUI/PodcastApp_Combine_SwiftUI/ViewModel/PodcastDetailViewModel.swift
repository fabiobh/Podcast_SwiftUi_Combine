import SwiftUI
import Combine

class PodcastDetailViewModel: ObservableObject {
    @Published var episodes: [PodcastEpisode] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchEpisodes(podcastId: String) {
        guard let request = APIConfig.createRequest(for: .podcastDetails(id: podcastId)) else { return }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PodcastDetailResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.episodes = response.episodes
            }
            .store(in: &cancellables)
    }
}

extension String {
    func removeHTMLTags() -> String {
        let stripped = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        return stripped
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
