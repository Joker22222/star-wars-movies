//
//  CoreDataHandler.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 04/08/2023.
//

import Foundation
import CoreData

class CoreDataHandler {
    
    //MARK: -1. PERSISTENT CONTROLLER
    static let shared = CoreDataHandler()
    
    //MARK: -1. PERSISTENT CONTAINER
    let container: NSPersistentContainer
    
    //MARK: -1. INITIALIZATION
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "StarWarsMoviesContainer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func addMovie(movie: Movie) {
        let newMovie = MoviesEntity(context: container.viewContext)
        newMovie.actors = movie.actors
        newMovie.imdbId = movie.imdbId
        newMovie.imgPoster = movie.imgPoster
        newMovie.title = movie.title
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving Movie \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getMovies() -> [Movie] {
        // Aquí implementa la lógica para obtener las películas guardadas en Core Data
        let request = NSFetchRequest<MoviesEntity>(entityName: "MoviesEntity")
        do {
            let moviesEntities = try container.viewContext.fetch(request)
            return moviesEntities.map { Movie(title: $0.title ?? "", imdbId: $0.imdbId ?? "", actors: $0.actors ?? "", imgPoster: $0.imgPoster ?? "") }
        } catch {
            print("Error fetching movies from Core Data. \(error)")
            return []
        }
    }
    
    func saveMovieDetailsToCoreData(details: MovieDetails) {
        let newMovieDetails = MoviesDetailsEntity(context: container.viewContext)
        newMovieDetails.imdbId = details.imdbId
        newMovieDetails.name = details.short.name
        newMovieDetails.image = details.short.image
        newMovieDetails.movieDescription = details.short.movieDescription
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving Movie Details \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getMovieDetails(imdbId: String) -> MovieDetails? {
        // Implementa la lógica para obtener los detalles de la película con el IMDb ID dado
        let request = NSFetchRequest<MoviesDetailsEntity>(entityName: "MoviesDetailsEntity")
        request.predicate = NSPredicate(format: "imdbId == %@", imdbId)
        do {
            let movieDetailsEntities = try container.viewContext.fetch(request)
            
            return movieDetailsEntities.first.map {
                return MovieDetails(short: ShortResponse(name: $0.name ?? "", image: $0.image ?? "", movieDescription: $0.movieDescription ?? ""), imdbId: imdbId)
            }
        } catch {
            print("Error fetching movie details from Core Data. \(error)")
            return nil
        }
    }
}

