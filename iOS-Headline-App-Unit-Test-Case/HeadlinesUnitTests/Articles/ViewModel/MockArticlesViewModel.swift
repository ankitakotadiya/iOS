//
//  MockArticlesViewModel.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 06/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import Foundation
@testable import Headlines

class MockArticlesViewModel: ArticlesViewProvider {
    
    var isError: Bool = false
    var isUpdated: Bool = false
    
    var updatedState: (() -> Void)?
    
    var state: ArticlesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }
    
    var articles: [Article] {
        let article: Article = Article()
        article.id = "1"
        article.headline = "Test Title"
        article.body = "Test Description"
        article.rawImageURL = "Test URL"
        article.isFavourite = false
        
        return [article]
    }
    
    func fetchArticlesfromNetwork() {
        if isError {
            self.state = .error("Error")
        } else {
            self.state = .loaded(articles)
        }
    }
    
    func fetchArticles() {
        fetchArticlesfromNetwork()
    }
    
    func updateObject(for article: Article) {
        article.isFavourite = article.isFavourite ? false : true
        isUpdated = true
    }
}
