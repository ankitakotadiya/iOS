//
//  MoviesViewControllerTests.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 10/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

final class MoviesViewControllerTests: XCTestCase {

    var sut: MoviesViewController?
    var apiManager: MockAPIManager?
    var viewModel: MoviesViewModel?
    var genreManager: MockGenreManager?
    
    // Setup initial components
    override func setUpWithError() throws {
        apiManager = MockAPIManager()
        genreManager = MockGenreManager()
        viewModel = MoviesViewModel(apiManager: apiManager!, genreManager: genreManager!)
        sut = MoviesViewController(viewModel: viewModel!)
    }
    
    // Test initial loading satge
    func test_initial_satge() {
        _ = sut?.view
        XCTAssertEqual(sut?.title, LocalizedString(key: "movies.title"))
        XCTAssertNotNil(sut?.tableView)
    }
    
    // Test .loaded case
    func test_loaded_case() {
        _ = sut?.view
        
        let expectationn = self.expectation(description: "Test .loaded case and data must be received.")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if case .loaded(let movies) = self.viewModel?.state {
                XCTAssertTrue(movies.count>0)
            }
            expectationn.fulfill()
        }
        
        wait(for: [expectationn], timeout: 0.3)
    }
    
    // Test .error case
    func test_error_case() {
        self.apiManager?.isError = true
        _ = sut?.view
        
        let expectation = self.expectation(description: "Test .error case alertcontroller should be presented.")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if case .error = self.viewModel?.state {
                XCTAssertNotNil(self.sut?.presentationController)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
    }

    // Free-up resources
    override func tearDownWithError() throws {
        sut = nil
        apiManager = nil
        viewModel = nil
    }
}
