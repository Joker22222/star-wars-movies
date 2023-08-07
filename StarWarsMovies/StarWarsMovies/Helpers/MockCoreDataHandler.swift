//
//  MockCoreDataHandler.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import Foundation

class MockCoreDataHandler: CoreDataHandlerProtocol {
    var storedMovies: [Movie] = []
    var storedMovieDetails: [MovieDetails] = []

    func addMovie(movie: Movie) {
        storedMovies.append(movie)
    }

    func getMovies() -> [Movie] {
        return storedMovies
    }

    func saveMovieDetailsToCoreData(details: MovieDetails) {
        storedMovieDetails.append(details)
    }

    func getMovieDetails(imdbId: String) -> MovieDetails? {
        return storedMovieDetails.first { $0.imdbId == imdbId }
    }
}
