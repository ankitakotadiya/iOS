//
//  FavouritesViewModelTests.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 06/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import XCTest
@testable import Headlines

final class FavouritesViewModelTests: XCTestCase {

    var viewModel: FavouritesViewProvider?
    var apiManager: MockNetworkManager?
    var dataManager: MockRealmDataManager?
    var articles: [Article] = []
    
    override func setUpWithError() throws {
        apiManager = MockNetworkManager()
        dataManager = MockRealmDataManager()
        viewModel = FavouritesViewModel(dataManager: dataManager!)
        self.createArticlesData()
    }
    
    func createArticlesData() {
        let article: Article = Article()
        article.id = "1"
        article.rawImageURL = "imageURL"
        article.body = "Test Body"
        article.headline = "Test Title"
        article.published = Date()
        article.isFavourite = true
        
        self.articles.append(article)
    }
    
    func test_fetch_objects() {
        dataManager?.setMockData(type: Article.self, data: self.articles)
        viewModel?.getFavouriesList()
        
        XCTAssertEqual(viewModel?.state.articles.count, 1)
    }
    
    func test_fetch_error() {
        dataManager?.setMockData(type: Article.self, data: [])
        viewModel?.getFavouriesList()
        
        XCTAssertEqual(viewModel?.state.articles.count, 0)
        XCTAssertEqual(viewModel?.state, .error("Database Error"))
    }
    
    func test_search_results() {
        viewModel?.state = .loaded(articles)
        
        viewModel?.getSearchResults(for: "Test", completion: { articles in
            XCTAssertEqual(articles.count, 1)
        })
    }

    override func tearDownWithError() throws {
        viewModel = nil
        apiManager = nil
        dataManager = nil
    }
}
