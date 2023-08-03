//
//  ContentView.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 02/08/2023.
//

//import SwiftUI
//import CoreData
//
//class StarWarsMoviesListViewModel: ObservableObject {
//
//    @Published var savedEntities: [MoviesEntity] = []
//    let container: NSPersistentContainer
//
//    init() {
//        container = NSPersistentContainer(name: "StarWarsMoviesContainer")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Error loading Core Data. \(error)")
//            }
//            fetchMovies()
//        }
//
//        func fetchMovies() {
//            let request = NSFetchRequest<MoviesEntity>(entityName: "MoviesEntity")
//            do {
//                try savedEntities = container.viewContext.fetch(request)
//            } catch let error {
//                print("Error fetching. \(error)")
//            }
//        }
//
//        func addMovie(movie: Movie) {
//            let newMovie = MoviesEntity(context: container.viewContext)
//            newMovie.imdbID = movie.imdbID
//            newMovie.title = movie.title
//            newMovie.actors = movie.actors
//            newMovie.imgPoster = movie.imgPoster
//            saveData()
//        }
//
//        func saveData(){
//            do {
//                try container.viewContext.save()
//                fetchMovies()
//            } catch let error {
//                print("Error saving. \(error)")
//            }
//        }
//    }
//}
//
//struct StarWarsMoviesList: View {
//
//    @StateObject var viewModel = StarWarsMoviesListViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StarWarsMoviesList()
//    }
//}


import SwiftUI
import CoreData
import WebKit

class StarWarsMoviesListViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let service = StarWarsMoviesService()
    let coreDataHandler = CoreDataHandler()
    
    init() {
        fetchMovies()
    }
    
    func fetchMovies() {
        isLoading = true
        service.fetchMovies { [weak self] movies, error in
            guard let self = self else { return }
            
            self.isLoading = false
            if let error = error {
                self.showAlert = true
                self.alertMessage = "Error al cargar los datos: \(error.localizedDescription)"
            } else if let movies = movies {
                // Si hay datos nuevos, los guardamos en Core Data si aún no existen
                if self.coreDataHandler.getMovies().isEmpty {
                    for movie in movies {
                        self.coreDataHandler.addMovie(movie: movie)
                    }
                }
                // Actualizamos la lista de películas en el ViewModel
                self.movies = movies
            }
        }
    }
}

struct StarWarsMoviesList: View {
    
    @StateObject var viewModel = StarWarsMoviesListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.movies) { movie in
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.title)
                            Text(movie.actors)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StarWarsMoviesList()
    }
}

// Capa de networking para la API
struct StarWarsMoviesService {
    let baseURL = "https://search.imdbot.workers.dev"
    
    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)?q=Star%20Wars") else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Result.self, from: data)
                    completion(result.description, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
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


// Métodos de Core Data
class CoreDataHandler {
    func addMovie(movie: Movie) {
        // Aquí implementa la lógica para guardar la película en Core Data
    }
    
    func getMovies() -> [Movie] {
        // Aquí implementa la lógica para obtener las películas guardadas en Core Data
        return []
    }
    
    // Puedes agregar más métodos según tus necesidades, como actualizar o eliminar películas.
}
