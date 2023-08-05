//
//  Movie.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 02/08/2023.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id = UUID()
    let title: String
    let imdbId: String
    let actors: String
    let imgPoster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "#TITLE"
        case imdbId = "#IMDB_ID"
        case actors = "#ACTORS"
        case imgPoster = "#IMG_POSTER"
    }
}

struct Result: Codable {
    let ok: Bool
    let description: [Movie]
    let errorCode: Int
    
    enum CodingKeys: String, CodingKey {
        case ok
        case description
        case errorCode = "error_code"
    }
}
