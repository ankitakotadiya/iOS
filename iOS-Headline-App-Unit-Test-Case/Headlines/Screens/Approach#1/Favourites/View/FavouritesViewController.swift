import UIKit
import SDWebImage

final class FavouritesViewController: UIViewController {
    
    private var viewModel: FavouritesViewProvider
    var searchViewController: UISearchController?
    weak var favouriteCoordinator: FavouritesChildCoordinators?

    init(viewModel: FavouritesViewProvider = FavouritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let articles = Article.all
    
    override func loadView() {
        self.view = FavouriteView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.presentationController?.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.title = "Favourites"
        
        if let contentview = self.contentView {
            self.configureTableView(contentview.tableView)
        }
        
        self.setupSearchController()
        self.bindViewModel()
        self.viewModel.getFavouriesList()
        
    }
    
    lazy var contentView: FavouriteView? = {
        return self.view as? FavouriteView
    }()
    
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
            print("Handle Loading Indicator Case.")
        case .loaded(let articles):
            if articles.count > 0 {
                let strTitle = articles.count > 1 ? "Favourites" : "Favourite"
                self.title = "\(articles.count) \(strTitle)"
            }
            self.contentView?.tableView.reloadData()
        case .error(let error):
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        self.displayAlert(message: message, actionTitle: "Okay")
    }
    
    private func configureTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: SubtitleCell.self)
    }
    
    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("FavouritesViewController Deallocated")
    }
    
    final class FavouriteView: UIView {
        var tableView = UITableView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setupTableView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupTableView() {
            addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            // Constraints for the table view
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}

// MARK: - UISearchResultsUpdating
extension FavouritesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    private func setupSearchController() {
        let searchresultVC = SearchResultsViewController<Article, SubtitleCell>()
        searchViewController = UISearchController(searchResultsController: searchresultVC)
        navigationItem.searchController = searchViewController
        searchViewController?.searchResultsUpdater = self
        searchViewController?.searchBar.placeholder = "Search"
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResult = searchController.searchResultsController as? SearchResultsViewController<Article,SubtitleCell> else {
            return
        }
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchResult.articles = []
            return
        }
        
        viewModel.getSearchResults(for: searchText) { articles in
            DispatchQueue.main.async {
                searchResult.articles = articles
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Perform search
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubtitleCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        
        let article = viewModel.state.articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
}

extension FavouritesViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    }
}
