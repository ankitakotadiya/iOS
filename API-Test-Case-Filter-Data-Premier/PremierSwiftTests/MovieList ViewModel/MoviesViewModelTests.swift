//
//  MoviesViewModelTests.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

final class MoviesViewModelTests: XCTestCase {
    
    var apiManager: MockAPIManager?
    var genreManager: MockGenreManager?
    var viewModel: MoviesViewModel?
    // Set-up resources
    override func setUpWithError() throws {
        self.apiManager = MockAPIManager()
        self.genreManager = MockGenreManager()
        self.viewModel = MoviesViewModel(apiManager: apiManager!, genreManager: genreManager!)
    }
    // Genre list success case
    func test_get_genre_list_success() {
        self.viewModel?.fetchGenres()
        XCTAssertEqual(self.genreManager?.genreName(for: 1), "Action")
        XCTAssertEqual(self.genreManager?.genreDictionary.count, 2)
    }
    
    // Genre list failure case
    func test_get_genre_list_failure() {
        self.apiManager?.isError = true
        self.viewModel?.fetchGenres()
        XCTAssertEqual(self.genreManager?.genreDictionary, [:])
    }
    
    // Fetch Movies success case
    func test_fetch_movies_success() {
        self.viewModel?.fetchData()
        
        if case .loaded(let movies) = self.viewModel?.state {
            XCTAssertEqual(movies.count, 1)
        }
    }
    
    // Fetch Movies error case
    func test_fetch_movies_error() {
        self.apiManager?.isError = true
        self.viewModel?.fetchData()
        
        if case .error = self.viewModel?.state {
            XCTAssertEqual(self.viewModel?.state.movies.count, 0)
        }
    }


    // Clean-up resources
    override func tearDownWithError() throws {
        apiManager = nil
        genreManager = nil
        viewModel = nil
    }

}
