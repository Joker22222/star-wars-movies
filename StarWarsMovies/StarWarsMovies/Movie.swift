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
    let imdbID: String
    let actors: String
    let imgPoster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "#TITLE"
        case imdbID = "#IMDB_ID"
        case actors = "#ACTORS"
        case imgPoster = "#IMG_POSTER"
    }
}
