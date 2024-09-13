import Foundation

protocol FavouritesViewProvider: AnyObject {
    func getFavouriesList()
    var updatedState: (() -> Void)? { get set }
    var state: FavouritesViewModelState {get set}
    func getSearchResults(for searchTerm: String, completion: @escaping ([Article]) -> Void)
}

enum FavouritesViewModelState: Equatable {
    case loading
    case loaded([Article])
    case error(String)
    
    var articles: [Article] {
        switch self {
        case .loaded(let articles):
            return articles
        case .loading, .error:
            return []
        }
    }
}

final class FavouritesViewModel: FavouritesViewProvider {
    private let dataManager: RealmManageable
    
    init(dataManager: RealmManageable = RealmManager()) {
        self.dataManager = dataManager
    }
    
    var updatedState: (() -> Void)?

    // The current state of the view model.
    var state: FavouritesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }
    
    func getFavouriesList() {
        // Define the predicate to filter favorite articles
        let predicate = NSPredicate(format: "isFavourite == true")
        
        // Fetch the favorite articles using the data manager
        if let favouriteArticles = dataManager.fetchObjects(ofType: Article.self, with: predicate) {
            self.state = .loaded(favouriteArticles)
        } else {
            self.state = .error("Database Error")
        }
    }
    
    func getSearchResults(for searchTerm: String, completion: @escaping ([Article]) -> Void) {
        let filteredArticles = self.state.articles.filter { article in
            article.headline.lowercased().contains(searchTerm.lowercased())
        }
        completion(filteredArticles)
    }
}
