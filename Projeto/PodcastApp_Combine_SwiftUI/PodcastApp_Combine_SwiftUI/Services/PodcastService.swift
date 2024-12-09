import Foundation
import Combine

class PodcastService: ObservableObject {
    @Published var podcasts: [Podcast] = []
    private var cancellables = Set<AnyCancellable>()
    public static let apiKey = "6a98e80f4ba54b7cb7b8578fec57755a"
    
    func fetchPodcasts() {
        guard let url = URL(string: "https://listen-api.listennotes.com/api/v2/best_podcasts") else { return }
        
        var request = URLRequest(url: url)
        request.setValue(PodcastService.apiKey, forHTTPHeaderField: "X-ListenAPI-Key")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PodcastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching podcasts: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.podcasts = response.podcasts
            }
            .store(in: &cancellables)
    }
}
