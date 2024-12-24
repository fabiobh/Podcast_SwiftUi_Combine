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
    
    /*
    func fetchCuratedPodcasts() {
        guard let request = APIConfig.createRequest(for: .curatedPodcasts) else { return }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PodcastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching curated podcasts: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.curatedPodcasts = response.podcasts
            }
            .store(in: &cancellables)
    }
    */
    
    /*
    func fetchRandomPodcastsV2() {
        guard let request = APIConfig.createRequest(for: .randomPodcasts) else { return }
        // guard let url = URL(string: "https://listen-api-test.listennotes.com/api/v2/just_listen") else { return }
        
        // var request = URLRequest(url: url)
     
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(Podcast.self, from: data)
                DispatchQueue.main.async {
                    self?.randomPodcasts = [result] // Since just_listen returns a single podcast
                }
            } catch {
                print("Error decoding random podcast:", error)
            }
        }.resume()
    }
    */
    
}
