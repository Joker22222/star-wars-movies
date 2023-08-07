//
//  StarWarsMoviesTests.swift
//  StarWarsMoviesTests
//
//  Created by Fernando Garay on 02/08/2023.
//

import XCTest
import Combine
@testable import StarWarsMovies

final class StarWarsMoviesListViewModelTests: XCTestCase {
    var viewModel: StarWarsMoviesListViewModel!
    var mockService: MockStarWarsMoviesService!
    var mockCoreDataHandler: MockCoreDataHandler!
    
    override func setUp() {
        super.setUp()
        mockCoreDataHandler = MockCoreDataHandler()
        mockService = MockStarWarsMoviesService()
        viewModel = StarWarsMoviesListViewModel(movies: nil, service: mockService, coreDataHandler: mockCoreDataHandler)
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
        mockCoreDataHandler = nil
        viewModel = nil
    }
    
    func testFetchMoviesAndDetails_NoInternetConnection() {
        // Given
        
        // Set up the fetchMoviesPublisher in the mock service
        let testMovies: [Movie] = [Movie(title: "Movie 1", imdbId: "tt000001", actors: "Actor 1", imgPoster: ""),
                                   Movie(title: "Movie 2", imdbId: "tt000002", actors: "Actor 2", imgPoster: "")]
        mockService.fetchMoviesPublisher = Just(testMovies).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        mockService.fetchMoviesPublisher = Fail(error: NSError(domain: "Test Error", code: 404, userInfo: nil)).eraseToAnyPublisher()
        
        // When
        viewModel.fetchMoviesAndDetails()
        
        // Then
        // Ensure that the movies and movie details are not fetched due to the error
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockCoreDataHandler.storedMovies.isEmpty)
        XCTAssertTrue(mockCoreDataHandler.storedMovieDetails.isEmpty)
        XCTAssertEqual(viewModel.alertTitle, "No Internet Connection")
    }
    
    func testFetchMovies_Error() {
        // Given
        mockService.fetchMoviesPublisher = Fail(error: NSError(domain: "Error", code: 100, userInfo: nil)).eraseToAnyPublisher()
        
        // When
        viewModel.fetchMoviesAndDetails()
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    
    func testFetchMoviesAndDetails_SuccessfulFetch() {
        // Given
        let mockService = MockStarWarsMoviesService()
        let mockCoreDataHandler = MockCoreDataHandler()
        let viewModel = StarWarsMoviesListViewModel(movies: nil, service: mockService, coreDataHandler: mockCoreDataHandler)
        
        // Set up the mock service to return some test movies and details
        let testMovies: [Movie] = [Movie(title: "Movie 1", imdbId: "tt000001", actors: "Actor 1", imgPoster: ""),
                                   Movie(title: "Movie 2", imdbId: "tt000002", actors: "Actor 2", imgPoster: "")]
        let testMovieDetails: [MovieDetails] = [MovieDetails(short: ShortResponse(name: "Movie 1", image: "", movieDescription: "", trailer: Trailer(embedUrl: "")), imdbId: "tt000001"),
                                                MovieDetails(short: ShortResponse(name: "Movie 2", image: "", movieDescription: "", trailer: Trailer(embedUrl: "")), imdbId: "tt000002")]
        mockService.fetchMoviesPublisher = Just(testMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        mockService.fetchMovieDetailsPublisher = Publishers.Sequence(sequence: testMovieDetails)
            .eraseToAnyPublisher()
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "Fetch movies and details")
        
        // When
        viewModel.fetchMoviesAndDetails()
        
        // Use a delay to allow time for the asynchronous calls to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            // Ensure that the movies and movie details are properly stored in the view model
            XCTAssertEqual(viewModel.movies.count, 2)
            XCTAssertEqual(mockCoreDataHandler.storedMovies.count, 2)
            XCTAssertEqual(mockCoreDataHandler.storedMovieDetails.count, 2)
            
            // Fulfill the expectation to indicate that the test is complete
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or time out after 5 seconds
        wait(for: [expectation], timeout: 5)
    }
}
