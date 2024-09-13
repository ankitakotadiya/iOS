import Foundation
import RealmSwift

protocol ArticlesViewProvider: AnyObject {
//    var articles: [Article] {get set}
    func fetchArticles()
    func updateObject(for article: Article)
    var updatedState: (() -> Void)? { get set }
    var state: ArticlesViewModelState {get set}
}

enum ArticlesViewModelState: Equatable {
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


final class ArticlesViewModel: ArticlesViewProvider {
    
    private let networkManager: NetworkManagerProvider
    private let dataManager: RealmManageable
    
    init(networkManager: NetworkManagerProvider = NetworkManager(), dataManager: RealmManageable = RealmManager()) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    var updatedState: (() -> Void)?

    // The current state of the view model.
    var state: ArticlesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }
    
    func fetchArticles() {
        
        if let articles = self.dataManager.fetchAll(Article.self), articles.count > 0 {
            self.state = .loaded(articles)
        } else {
            let params = ["q":"fintech", "show-fields": "main,body", "api-key": "\(API.apiKey)"]
            DispatchQueue.global().async {
                self.networkManager.execute(request: Article.getHeadlines(for: params)) { responseData, error in
                    DispatchQueue.main.async {
                        if let articles = responseData?.results {
                            self.state = .loaded(articles)
                            self.dataManager.save(objects: articles)
                        } else if let err = error {
                            self.state = .error(err.localizedDescription)
                        } else {
                            self.state = .loading
                        }
                    }
                }
            }
        }
    }
    
    func updateObject(for article: Article) {
        self.dataManager.updateObject(withPrimaryKey: article.id) { (articleObj: Article) in
            articleObj.isFavourite = article.isFavourite ? false : true
        }
    }
}
