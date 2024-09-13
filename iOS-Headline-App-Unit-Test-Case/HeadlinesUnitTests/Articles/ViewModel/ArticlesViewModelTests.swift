//
//  ArticlesViewModelTests.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 05/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import XCTest
@testable import Headlines

final class ArticlesViewModelTests: XCTestCase {
    
    var dataManager : MockRealmDataManager?
    var apiManager : MockNetworkManager?
    var viewModel: ArticlesViewProvider?
    var articles: [Article] = []

    private var jsonStr: String {
        return """
        {
            "response": {
                "results": [
                    {
                        "id": "1",
                        "webTitle": "Test Title",
                        "fields" : {
                            "body": "Test Description",
                            "main": "Test URL"
        
                        }
                    }
                ]
            }
        }
        """
    }
    
    override func setUpWithError() throws {
        dataManager = MockRealmDataManager()
        apiManager = MockNetworkManager()
        viewModel = ArticlesViewModel(networkManager: apiManager!, dataManager: dataManager!)
        self.createArticlesData()
    }
    
    func createArticlesData() {
        let article: Article = Article()
        article.id = "1"
        article.rawImageURL = "imageURL"
        article.body = "Test Body"
        article.headline = "Test Title"
        article.published = Date()
        article.isFavourite = false
        
        self.articles.append(article)
    }
    
    func test_fetch_data_from_database() {
        dataManager?.setMockData(type: Article.self, data: articles)
        viewModel?.fetchArticles()
        XCTAssertTrue(viewModel?.state.articles.count == 1)
    }
        
    func test_fetch_data_from_api() {
        dataManager?.setMockData(type: Article.self, data: [])
        apiManager?.setMockData(for: Page<Article>.self, jsonString: jsonStr)
        
        viewModel?.fetchArticles()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state.articles, self.articles)
            XCTAssertEqual(self.dataManager?.mockData.count, 1)
        }
    }
    
    func test_fetch_data_from_api_error() {
        dataManager?.setMockData(type: Article.self, data: [])
        apiManager?.shouldReturnError = true
        
        viewModel?.fetchArticles()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel?.state.articles, [])
            XCTAssertEqual(self.viewModel?.state, .error(MockError.invalidResponse.localizedDescription))
        }
    }
    
    func test_update_data() {
        guard let articleObj = self.articles.first else {return}
        self.dataManager?.setMockData(type: Article.self, data: articles)
        self.viewModel?.updateObject(for: articleObj)
        DispatchQueue.main.async {
            XCTAssertEqual(articleObj.isFavourite, true)
        }
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        apiManager = nil
        dataManager = nil
    }
}
