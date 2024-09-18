//
//  MovieDetailViewModelTests.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

final class MovieDetailViewModelTests: XCTestCase {
    
    var apiManager: MockAPIManager?
    var viewModel: MoviesDetailsViewModel?

    private let testMovie: Movie = {
        return Movie(id: 1, title: "Test Movie", overview: "Test Movie Overview", posterPath: nil, voteAverage: 5.0, genreIds: [1,2])
    }()
    
    // Set up resources before each test
    override func setUpWithError() throws {
        self.apiManager = MockAPIManager()
        self.viewModel = MoviesDetailsViewModel(movie: testMovie, apiManager: self.apiManager!)
    }
    
    // Test initial loading state of the view model
    func test_Initial_Stage_Loading() {
        XCTAssertEqual(viewModel?.state.title, "Test Movie")
    }
    
    // Test fetching movie details with a successful result
    func test_fetch_movie_detail_data_success() {
        self.viewModel?.fetchData()
        
        XCTAssertEqual(self.viewModel?.movieDetail?.title, "Test Movie Detail")
    }
    
    // Test fetching movie details with an error response
    func test_fetch_movie_detail_data_error() {
        self.apiManager?.isError = true
        self.viewModel?.fetchData()
        
        XCTAssertNil(self.viewModel?.state.movieDetails)
        XCTAssertNil(self.viewModel?.state.title)
        XCTAssertEqual(self.viewModel?.state, .error)
    }
    
    // Test fetching similar movies with an error response
    func test_fetch_similarmovie_error() {
        self.apiManager?.isError = true
        self.viewModel?.fetchSimilarMovie()
        
        XCTAssertTrue(self.viewModel?.state.movie?.count == 0)
    }
    
    // Fetch Similar Movie Success Block.
    func test_fetch_similarmovie_success() {
        self.viewModel?.fetchSimilarMovie()
        
        XCTAssertEqual(self.viewModel?.similarMovie?.count, 1)
        XCTAssertEqual(self.viewModel?.similarMovie?.first?.title, "Test Movie")
    }
    
    // Test fetching both movie details and similar movies with success
    func test_fetch_moviedetail_similarmovie_success() {
        self.apiManager?.isError = false
        let expectation = self.expectation(description: "State should be updated to loaded")
        
        viewModel?.updatedState = {
            if case .loaded(let movieData) = self.viewModel?.state {
                XCTAssertEqual(movieData.details.title, self.viewModel?.movieDetail?.title)
                XCTAssertTrue(movieData.similarMovie.count > 0)
                expectation.fulfill()
            }
        }
        
        viewModel?.updateUI()
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_fetch_moviedetail_similarmovie_error() {
        self.apiManager?.isError = true
        
        let expectation = self.expectation(description: "The state should be updated with error.")
        var didFulfill = false
        
        viewModel?.updatedState = {
            guard !didFulfill else {return}
            if case .error = self.viewModel?.state {
                XCTAssertEqual(self.viewModel?.state, .error)
                didFulfill = true
                expectation.fulfill()
            } else {
                XCTAssertNil(self.viewModel?.movieDetail)
            }
        }
        viewModel?.updateUI()
        wait(for: [expectation], timeout: 0.1)
    }

    // Clean-up resources
    override func tearDownWithError() throws {
        // Clean up resources
        apiManager = nil
        viewModel = nil
    }
}
