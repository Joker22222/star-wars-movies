//
//  Movie.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 02/08/2023.
//

import Foundation

struct MovieDetails: Codable {
    let short: ShortResponse
    let imdbId: String
}

struct ShortResponse: Codable {
    let name: String
    let image: String
    let movieDescription: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case movieDescription = "description"
    }
}

