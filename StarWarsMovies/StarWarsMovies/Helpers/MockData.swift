//
//  MockData.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 06/08/2023.
//

import Foundation

struct MockData {
    public static let mockMovie = Movie(title: "Rogue One", imdbId: "", actors: "Dave Fiolini", imgPoster: "")
    // swiftlint:disable line_length
    public static let mockMovieArray = [Movie(title: "Rogue One", imdbId: "", actors: "Dave Fiolini", imgPoster: ""), Movie(title: "Star Wars: Episode IV - A New Hope", imdbId: "", actors: "Dave Fiolini", imgPoster: ""), Movie(title: "Star Wars: The Bad Batch", imdbId: "", actors: "Ewan McGregor, Liam Neeson", imgPoster: "")]
    // swiftlint:disable line_length
    public static let mockMovieDetails = MovieDetails(short: ShortResponse(name: "Star Wars", image: "https://m.media-amazon.com/images/M/MV5BMjEwMzMxODIzOV5BMl5BanBnXkFtZTgwNzg3OTAzMDI@._V1_.jpg", movieDescription: "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire&apos;s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth ...", trailer: Trailer(embedUrl: "https://bit.ly/swswift")), imdbId: "")
}
