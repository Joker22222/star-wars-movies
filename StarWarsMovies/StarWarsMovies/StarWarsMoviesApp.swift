//
//  StarWarsMoviesApp.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 02/08/2023.
//

import SwiftUI
import CoreData

@main
struct StarWarsMoviesApp: App {
    var body: some Scene {
        WindowGroup {
            StarWarsMoviesList(viewModel: StarWarsMoviesListViewModel(movies: nil)).environmentObject(NetworkMonitor.shared)
        }
    }
}
