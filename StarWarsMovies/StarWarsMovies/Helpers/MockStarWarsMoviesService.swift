//
//  MockStarWarsMoviesService.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import Foundation
import Combine

class MockStarWarsMoviesService: StarWarsMoviesServiceProtocol {
    var fetchMoviesPublisher: AnyPublisher<[Movie], Error> = Empty().eraseToAnyPublisher()
    var fetchMovieDetailsPublisher: AnyPublisher<MovieDetails, Error> = Empty().eraseToAnyPublisher()

    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        return fetchMoviesPublisher
    }

    func fetchMovieDetails(imdbId: String) -> AnyPublisher<MovieDetails, Error> {
        return fetchMovieDetailsPublisher
    }
}
