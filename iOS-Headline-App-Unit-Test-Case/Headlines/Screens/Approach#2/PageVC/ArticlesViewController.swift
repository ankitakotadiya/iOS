import UIKit

final class ArticlesViewController: UIViewController {
    
    private let viewModel: ArticlesViewProvider
    var mainCoordinator : ArticlesChildCoordinator?
    
    init(viewModel: ArticlesViewProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
    }
    
    private lazy var pageViewController: ArticlePageViewController = {
        let pageVC = ArticlePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.articledelegate = self
        return pageVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Additional setup after ViewDidLoad
        self.title = "Articles"
        self.setUpPageView()
        self.bindViewModel()
        self.viewModel.fetchArticles()
    }
    
    private func setUpPageView() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.updatedState = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateFromViewModel()
            }
        }
    }
    
    private func updateFromViewModel() {
        switch viewModel.state {
        case .loading:
            print("Handle Loading Indicator Flow.")
        case .loaded(let articles):
            self.loadArticles(articles: articles)
        case .error(let error):
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        self.displayAlert(message: message, actionTitle: "Okay")
    }
    
    private func loadArticles(articles: [Article]) {
        self.pageViewController.articles = articles
        if let firstViewController = self.pageViewController.viewControllerAtIndex(index: 0) {
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - ArticleCollectionViewCellDelegate
extension ArticlesViewController: ArticleCollectionViewCellDelegate {
    func addToFavourite(for article: Article) {
        viewModel.updateObject(for: article)
    }
    
    func didRequestToOpenFavoritesList() {
        mainCoordinator?.navigateToFavouritesVC()
    }
}

