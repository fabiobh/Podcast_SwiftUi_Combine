import Foundation
import Combine

class PodcastService: ObservableObject {
    @Published var podcasts: [Podcast] = []
    @Published var curatedPodcasts: [Podcast] = []
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
    
    func fetchCuratedPodcasts() {
        guard let request = APIConfig.createRequest(for: .curatedPodcasts) else { return }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CuratedPodcastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching curated podcasts: \(error)")
                }
            } receiveValue: { [weak self] response in
                // Get all podcasts from all curated lists and flatten them into a single array
                self?.curatedPodcasts = response.curated_lists.flatMap { $0.podcasts }
            }
            .store(in: &cancellables)
    }
        
}
