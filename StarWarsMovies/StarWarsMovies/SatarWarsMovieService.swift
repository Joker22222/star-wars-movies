//
//  SatarWarsMovieService.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 04/08/2023.
//

import Foundation
import Combine

struct StarWarsMoviesService {
    private let baseURL = "https://search.imdbot.workers.dev/"
    
    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: "\(baseURL)?q=Star%20Wars") else {
            return Fail(error: NSError(domain: "Invalid URL", code: -1, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Result.self, decoder: JSONDecoder())
            .map(\.description)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(imdbId: String) -> AnyPublisher<MovieDetails, Error> {
        guard let url = URL(string: "\(baseURL)?tt=\(imdbId)") else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetails.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
