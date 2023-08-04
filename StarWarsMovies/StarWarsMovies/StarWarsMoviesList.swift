
import SwiftUI

struct StarWarsMoviesList: View {
    @StateObject var viewModel = StarWarsMoviesListViewModel(movies: nil)
    
    init(viewModel: StarWarsMoviesListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                MovieRow(viewModel: MovieRowViewModel(movie: movie))
            }
            .navigationTitle("Star Wars Movies")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StarWarsMoviesList(viewModel: StarWarsMoviesListViewModel(movies: [Movie(title: "Rogue One", imdbId: "", actors: "", imgPoster: "")]))
    }
}

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack {
            if let movieDetails = viewModel.movieDetails {
                Text(movieDetails.short.name)
                    .font(.title)
                    .padding()
                Text(movieDetails.short.movieDescription)
                    .padding()
            } else {
                ProgressView()
            }
        }
    }
}

class MovieRowViewModel: ObservableObject {
    let movie: Movie
    var imdbId: String {
        movie.imdbId
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}

struct MovieRow: View {
    @StateObject private var viewModel: MovieRowViewModel
    
    init(viewModel: MovieRowViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(imdbId: viewModel.imdbId))) {
            HStack(spacing: 10) {
                // Poster Image (assuming you have a method to load the image from URL)
                AsyncImage(url: URL(string: viewModel.movie.imgPoster)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 90) // Adjust the size of the poster thumbnail
                        .cornerRadius(10)
                } placeholder: {
                    Color.gray // Placeholder while loading the image
                        .frame(width: 60, height: 90)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(viewModel.movie.actors)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}



