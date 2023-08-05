//
//  StarWarsMoviesListViewModel.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 04/08/2023.
//

import Foundation
import Combine


class StarWarsMoviesListViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published private var movieDetailsDictionary: [String: MovieDetails] = [:]
    
    let service = StarWarsMoviesService()
    let coreDataHandler = CoreDataHandler()
    private var cancellables = Set<AnyCancellable>()
    
    init(movies: [Movie]?) {
        if let movies = movies {
            self.movies = movies
        } else {
            fetchMoviesAndDetails()
        }
    }
    
    func fetchMoviesAndDetails() {
        isLoading = true
        service.fetchMovies()
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] movies -> AnyPublisher<[MovieDetails], Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "ViewModel deallocated", code: 0, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                // Save movies to Core Data if not already saved
                if self.coreDataHandler.getMovies().isEmpty {
                    for movie in movies {
                        self.coreDataHandler.addMovie(movie: movie)
                    }
                }
                self.movies = self.coreDataHandler.getMovies()
                // Get unique IMDb IDs from movies
                let imdbId = Set(movies.map { $0.imdbId })
                // Fetch details for each movie using Combine
                let movieDetailsPublishers = imdbId
                    .map { self.service.fetchMovieDetails(imdbId: $0) }
                // Merge all publishers into one
                return Publishers.MergeMany(movieDetailsPublishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.showAlert = true
                    self.alertMessage = "Error al cargar los datos: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] movieDetails in
                guard let self = self else { return }
                // Save movie details to Core Data
                for details in movieDetails {
                    // Check if the details for this IMDb ID already exist in Core Data
                    if self.coreDataHandler.getMovieDetails(imdbId: details.short.name) != nil {
                        // Details already exist, skip saving
                        continue
                    }
                    // Details do not exist, save them
                    self.coreDataHandler.saveMovieDetailsToCoreData(details: details)
                }
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
}
