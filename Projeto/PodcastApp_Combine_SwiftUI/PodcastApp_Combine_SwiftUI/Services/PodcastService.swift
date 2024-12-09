import Foundation
import Combine

class PodcastService: ObservableObject {
    @Published var podcasts: [Podcast] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPodcasts() {
        guard let request = APIConfig.createRequest(for: .bestPodcasts) else { return }
        
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
