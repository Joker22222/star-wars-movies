//
//  MovieDetailsViewModel.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 04/08/2023.
//

import Foundation
import Combine

//class MovieDetailsViewModel: ObservableObject {
//    @Published var movieDetails: MovieDetails?
//    let service = StarWarsMoviesService()
//    private var cancellables = Set<AnyCancellable>()
//
//    func fetchMovieDetails(imdbId: String) {
//        // Check if movie details exist in Core Data
//        if let cachedDetails = CoreDataHandler.shared.getMovieDetails(imdbId: imdbId) {
//            movieDetails = cachedDetails
//            return
//        }
//    }
//}

class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    let service = StarWarsMoviesService()
    var imdbId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(imdbId: String) {
        self.imdbId = imdbId
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        // Check if movie details exist in Core Data
        if let cachedDetails = CoreDataHandler.shared.getMovieDetails(imdbId: imdbId) {
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
                CoreDataHandler.shared.saveMovieDetailsToCoreData(details: movieDetails)
            })
            .store(in: &cancellables)
    }
}
