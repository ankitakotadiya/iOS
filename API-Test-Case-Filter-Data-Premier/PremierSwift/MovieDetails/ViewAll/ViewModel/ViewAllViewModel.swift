//
//  ViewAllViewModel.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 12/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation

enum ViewAllModelState: Equatable {
    static func == (lhs: ViewAllModelState, rhs: ViewAllModelState) -> Bool {
        return true
    }
    
    case loading
    case loaded([Movie])
    case error

    var movie: [Movie]? {
        switch self {
        case .loaded(let movies):
            return movies
        case .loading, .error:
            return []
        }
    }
}

class ViewAllViewModel {
    private let apiManager: APIManaging
    let initialMovie: Movie
    var currentPage: Int = 1
    var totalPage: Int = 3
    
    init(apiManager: APIManaging = APIManager(), initialMovie: Movie) {
        self.apiManager = apiManager
        self.initialMovie = initialMovie
    }
    
    var state: ViewAllModelState = .loading {
        didSet {
            updateFromState?()
        }
    }
    
    var updateFromState: (() -> Void)?
    
    // Fetch similar movies.
    func fetchSimilarMovie() {
        apiManager.execute(Movie.similarMovie(for: initialMovie, queryParams: ["page": "\(currentPage)"])) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let page):
                self.currentPage += 1
                self.totalPage = page.totalPages
                print("Page Count is:",page.results.count)
                self.state = .loaded(page.results)
            case .failure:
                self.state = .error
            }
        }
    }
}
