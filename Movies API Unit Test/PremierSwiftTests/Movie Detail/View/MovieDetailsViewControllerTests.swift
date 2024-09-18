//
//  MovieDetailsViewControllerTests.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 10/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

final class MovieDetailsViewControllerTests: XCTestCase {

    var sut: MovieDetailsViewController?
    var apiManager: MockAPIManager?
    var viewModel: MoviesDetailsViewModel?
    private let testMovie: Movie = {
        return Movie(id: 1, title: "Test Movie", overview: "Test Movie Overview", posterPath: nil, voteAverage: 5.0, genreIds: [1,2])
    }()
    
    // Setup initialise state
    override func setUpWithError() throws {
        apiManager = MockAPIManager()
        viewModel = MoviesDetailsViewModel(movie: testMovie, apiManager: apiManager!)
        sut = MovieDetailsViewController(viewModel: viewModel!)
    }
    
    // Test loading indicator is loading
    func test_initial_loading_stage() {
        _ = sut?.view
        
        let expectation = self.expectation(description: "Check Indicator is loading.")
        DispatchQueue.main.async {
            XCTAssertTrue(self.sut?.currentViewController is LoadingViewController)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    // Test MovieDetailDesplayController is loaded
    func test_loaded_state() {
        _ = sut?.view
        let expectation = self.expectation(description: "MoviesDetailDisplayController must be loaded")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if case .loaded(let details) = self.viewModel?.state {
                XCTAssertEqual(self.sut?.title, details.details.title)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
    }
        
    // Test .error case
    func test_error_stage() {
        self.apiManager?.isError = true
        _ = sut?.view
        
        let expectation = self.expectation(description: "Error must be received and alert is presented")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if case .error = self.viewModel?.state {
                XCTAssertNotNil(self.sut?.presentationController)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
    }

    // Clean-up resources
    override func tearDownWithError() throws {
        viewModel = nil
        apiManager = nil
        sut = nil
    }
}
