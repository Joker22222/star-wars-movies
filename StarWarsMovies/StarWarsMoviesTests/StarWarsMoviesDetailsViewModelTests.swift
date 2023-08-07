//
//  StarWarsMoviesDetailsViewModelTests.swift
//  StarWarsMoviesTests
//
//  Created by Fernando Garay on 06/08/2023.
//

import Foundation
import XCTest
import Combine

@testable import StarWarsMovies

final class StarWarsMoviesDetailsViewModelTests: XCTestCase {

    var viewModel: MovieDetailsViewModel!
    var mockService: MockStarWarsMoviesService!
    var mockCoreDataHandler: MockCoreDataHandler!
    
    override func setUp() {
        super.setUp()
        mockCoreDataHandler = MockCoreDataHandler()
        mockService = MockStarWarsMoviesService()
        viewModel = MovieDetailsViewModel(imdbId: "tt000001", movieDetails: nil, service: mockService, coreDataHandler: mockCoreDataHandler)
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
        mockCoreDataHandler = nil
        viewModel = nil
    }
    
    func testFetchMovieDetails_FetchError() {
        // Given
        let testError = URLError(.badServerResponse)
        mockService.fetchMovieDetailsPublisher = Fail<MovieDetails, Error>(error: testError)
            .eraseToAnyPublisher()
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "Fetch Movie Details Error")
        
        // When
        viewModel.fetchMovieDetails()
        
        // Then
        // Ensure that the movie details are not set in the view model
        DispatchQueue.main.async {
            XCTAssertNil(self.viewModel.movieDetails)
            expectation.fulfill() // Fulfill the expectation after the assertions
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMovieDetails_SuccessfulFetch() {
        // Given
        // Set up the mock service to return some test movie details
        let testMovieDetails = MovieDetails(short: ShortResponse(name: "Movie 1", image: "", movieDescription: "", trailer: Trailer(embedUrl: "")), imdbId: "tt000001")
        mockService.fetchMovieDetailsPublisher = Just(testMovieDetails)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "Fetch Movie Details")
        
        // When
        viewModel.fetchMovieDetails()
        
        // Then
        // Ensure that the movie details are properly stored in the view model
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.movieDetails?.short.name, testMovieDetails.short.name)
            XCTAssertEqual(self.viewModel.movieDetails?.short.image, testMovieDetails.short.image)
            XCTAssertEqual(self.viewModel.movieDetails?.short.movieDescription, testMovieDetails.short.movieDescription)
            XCTAssertEqual(self.viewModel.movieDetails?.short.trailer.embedUrl, testMovieDetails.short.trailer.embedUrl)
            XCTAssertEqual(self.viewModel.movieDetails?.imdbId, testMovieDetails.imdbId)
            expectation.fulfill() // Fulfill the expectation after the assertions
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
}
