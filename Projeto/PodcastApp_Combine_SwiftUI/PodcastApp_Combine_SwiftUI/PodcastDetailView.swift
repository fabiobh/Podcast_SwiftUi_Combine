import SwiftUI
import Combine

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
}

struct PodcastDetailResponse: Decodable {
    let episodes: [PodcastEpisode]
    
    enum CodingKeys: String, CodingKey {
        case episodes = "episodes"
    }
}

class PodcastDetailViewModel: ObservableObject {
    @Published var episodes: [PodcastEpisode] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchEpisodes(podcastId: String) {
        guard let url = URL(string: "https://listen-api.listennotes.com/api/v2/podcasts/\(podcastId)?sort=recent_first") else { return }
        
        var request = URLRequest(url: url)
        request.addValue(PodcastService.apiKey, forHTTPHeaderField: "X-ListenAPI-Key")
        
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

struct PodcastDetailView: View {
    let podcastId: String
    let podcastTitle: String
    @StateObject private var viewModel = PodcastDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(podcastTitle)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                ForEach(viewModel.episodes) { episode in
                    EpisodeDetailCard(episode: episode)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchEpisodes(podcastId: podcastId)
        }
    }
}

struct EpisodeDetailCard: View {
    let episode: PodcastEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: episode.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            
            Text(episode.title)
                .font(.headline)
            
            Text(episode.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            HStack {
                Text(formatDate(episode.publishedAt))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(formatDuration(episode.duration))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private func formatDate(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }
}
