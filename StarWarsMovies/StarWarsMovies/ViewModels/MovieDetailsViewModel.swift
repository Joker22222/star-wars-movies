//
//  MovieDetailsViewModel.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 04/08/2023.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    let service: StarWarsMoviesServiceProtocol
    let coreDataHandler : CoreDataHandlerProtocol
    let playTrailerButtonText = "Play Trailer"
    let primaryColorIdentifier = "PrimaryColor"
    let circleShapeIdentifier = "play.circle.fill"
    var imdbId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(imdbId: String, movieDetails: MovieDetails?, service: StarWarsMoviesServiceProtocol, coreDataHandler: CoreDataHandlerProtocol) {
        self.coreDataHandler = coreDataHandler
        self.service = service
        if let movieDetails = movieDetails {
            self.movieDetails = movieDetails
            self.imdbId = imdbId
        } else {
            self.imdbId = imdbId
            fetchMovieDetails()
        }
    }
    
    func fetchMovieDetails() {
        // Check if movie details exist in Core Data
        if let cachedDetails = coreDataHandler.getMovieDetails(imdbId: imdbId) {
            movieDetails = cachedDetails
            return
        }
        
        // If details don't exist in Core Data, fetch from API
        service.fetchMovieDetails(imdbId: imdbId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished :
                    break
                case .failure(let error):
                    print("Error fetching movie details: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] movieDetails in
                self?.movieDetails = movieDetails
                // Save movie details to Core Data
                self?.coreDataHandler.saveMovieDetailsToCoreData(details: movieDetails)
            })
            .store(in: &cancellables)
    }
}
