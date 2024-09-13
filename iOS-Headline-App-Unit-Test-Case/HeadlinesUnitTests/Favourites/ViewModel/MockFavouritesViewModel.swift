//
//  MockFavouritesViewModel.swift
//  ArticlesViewModelTests
//
//  Created by Ankita Kotadiya on 06/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import Foundation
@testable import Headlines

class MockFavouritesViewModel: FavouritesViewProvider {
    
    var updatedState: (() -> Void)?
    var isError: Bool = false
    var state: FavouritesViewModelState = .loading {
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
    
    func getFavouriesList() {
        if isError {
            self.state = .error("Error")
        } else {
            self.state = .loaded(articles)
        }
    }
    
    func getSearchResults(for searchTerm: String, completion: @escaping ([Article]) -> Void) {
        completion(articles)
    }
}
