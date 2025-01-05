import SwiftUI

struct MovieView: View {
    @StateObject private var store: MovieStore = MovieStore()
    
    var body: some View {
        NavigationView {
            ZStack {
                movieList
                
                if store.state.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("박스오피스")
            
        }
        .onAppear { store.dispatch(.onAppear) }
    }
    
    private var movieList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(store.state.movies) { movie in
                    MovieCell(movie: movie)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            if let index = store.state.movies.firstIndex(where: { $0.id == movie.id }) {
                                store.dispatch(.movieSelected(index))
                            }
                        }
                }
            }
            .padding(.vertical, 10)
        }
        .refreshable {
            store.dispatch(.refresh)
        }
    }
}

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(movie.rank)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(movie.title)
                    .font(.headline)
                
                Spacer()
                
                if movie.rankIntensity != 0 {
                    Image(systemName: movie.rankIntensity > 0 ? "arrow.up" : "arrow.down")
                        .foregroundColor(movie.rankIntensity > 0 ? .red : .blue)
                    Text("\(abs(movie.rankIntensity))")
                }
            }
            
            HStack {
                Text("관객수: \(movie.audienceCount.formattedWithCommas)명")
                Spacer()
                Text("누적: \(movie.totalAudience.formattedWithCommas)명")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Divider()
        }
        .padding(.vertical, 8)
    }
}

extension Int {
    var formattedWithCommas: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}

#Preview {
    MovieView()
}

