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
    
    static func ==(lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.imdbId == rhs.imdbId
    }
}

struct ShortResponse: Codable {
    let name: String
    let image: String
    let movieDescription: String
    let trailer: Trailer
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case movieDescription = "description"
        case trailer
    }
}

struct Trailer: Codable {
    let embedUrl: String
}

