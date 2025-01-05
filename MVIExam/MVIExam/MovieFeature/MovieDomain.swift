import Foundation

// State
struct MovieState: Equatable {
    var movies: [Movie] = []
    var isLoading: Bool = false
    var error: String? = nil
}

// Intent (User Actions)
enum MovieIntent {
    case onAppear
    case refresh
    case movieSelected(Int)
    case loadMovies
}

// Effect (Side Effects)
enum MovieEffect {
    case fetchMovies
    case showError(String)
} 