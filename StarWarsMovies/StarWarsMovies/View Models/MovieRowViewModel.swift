//
//  MovieRowViewModel.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import Foundation

class MovieRowViewModel: ObservableObject {
    let movie: Movie
    let primaryColorIdentifier = "PrimaryColor"
    var imdbId: String {
        movie.imdbId
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
