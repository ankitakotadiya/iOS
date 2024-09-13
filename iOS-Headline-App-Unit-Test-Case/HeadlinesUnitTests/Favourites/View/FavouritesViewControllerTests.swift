//
//  FavouritesViewControllerTests.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 06/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import XCTest
@testable import Headlines

final class FavouritesViewControllerTests: XCTestCase {

    var viewModel: MockFavouritesViewModel?
    var sut: FavouritesViewController?
    
    override func setUpWithError() throws {
        viewModel = MockFavouritesViewModel()
        sut = FavouritesViewController(viewModel: viewModel!)
    }
    
    func test_initial_loading_state() {
        _ = sut?.view
        
        XCTAssertEqual(sut?.title, "Favourites")
        XCTAssertNotNil(sut?.contentView)
        XCTAssertNotNil(sut?.contentView?.tableView)
        XCTAssertNotNil(sut?.searchViewController)
    }
    
    func test_loaded_state() {
        viewModel?.isError = false
        _ = sut?.view
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state.articles.count, 1)
        }
    }
    
    func test_error_state() {
        viewModel?.isError = true
        _ = sut?.view
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state, .error("Error"))
            XCTAssertEqual(self.viewModel?.state.articles.count, 0)
        }
    }
    
    func test_search_empty_result() {
        _ = sut?.view
        
        sut?.searchViewController?.searchBar.text = ""
        
        if let searchResultVC = sut?.searchViewController?.searchResultsController as? SearchResultsViewController<Article,SubtitleCell> {
            XCTAssertEqual(searchResultVC.articles.count, 0)
        }
    }
    
    func test_search_result() {
        _ = sut?.view
        
        sut?.searchViewController?.searchBar.text = "Test"
        
        guard let searchResultVC = sut?.searchViewController?.searchResultsController as? SearchResultsViewController<Article,SubtitleCell> else {return}
        
        DispatchQueue.main.async {
            XCTAssertEqual(searchResultVC.articles.count, 1)
        }
    }


    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
}
