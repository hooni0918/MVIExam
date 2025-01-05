import Foundation

@MainActor
final class MovieStore: ObservableObject {
    @Published private(set) var state: MovieState
    private let apiService: MovieAPIService
    
    init(initialState: MovieState = MovieState(), apiService: MovieAPIService = MovieAPIService()) {
        self.state = initialState
        self.apiService = apiService
    }
    
    func dispatch(_ intent: MovieIntent) {
        switch intent {
        case .onAppear, .refresh:
            dispatch(.loadMovies)
            
        case .loadMovies:
            Task {
                do {
                    state.isLoading = true
                    state.error = nil
                    
                    let movies = try await apiService.fetchMovies()
                    state.movies = movies
                    state.isLoading = false
                } catch {
                    state.error = error.localizedDescription
                    state.isLoading = false
                }
            }
            
        case .movieSelected(let index):
            print("Selected movie at index: \(index)")
        }
    }
} 