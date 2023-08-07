
import SwiftUI

struct StarWarsMoviesList: View {
    @StateObject var viewModel = StarWarsMoviesListViewModel(movies: nil, service: StarWarsMoviesService(), coreDataHandler: CoreDataHandler.shared)
    
    @StateObject var networkStatus = NetworkMonitor.shared
    
    init(viewModel: StarWarsMoviesListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                MovieRow(viewModel: MovieRowViewModel(movie: movie))
            }.scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.large)
                .navigationBarTitle(viewModel.viewTitle)
        }.tint(.white)
            .alert(isPresented: $networkStatus.hasLostConnection) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text(viewModel.alertDismissButton))
                )
            }
    }
}

struct StarWarsMoviesList_Previews: PreviewProvider {
    static var previews: some View {
        StarWarsMoviesList(viewModel: StarWarsMoviesListViewModel(movies: [MockData.mockMovie], service: StarWarsMoviesService(), coreDataHandler: CoreDataHandler.shared))
    }
}
