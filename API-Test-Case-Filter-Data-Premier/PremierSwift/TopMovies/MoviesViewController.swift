import UIKit

final class MoviesViewController: UITableViewController {
    
    private let viewModel: MoviesViewModelProvider
    private var searchController: UISearchController?
    private var dispatchItem: DispatchWorkItem?
    
    init(viewModel: MoviesViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedString(key: "movies.title")

        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(filterButtonTapped(_:)))
        navigationController?.navigationBar.tintColor = UIColor.Brand.popsicle40

        self.setupSearchbar()
        configureTableView()
        updateFromViewModel()
        bindViewModel()
        DispatchQueue.global().async {
            self.viewModel.fetchData()
        }
        // I have called this API in movie list controller as it has nothing to do with any movie id so concurrently call and save data globally. If I would have called in Movie Detail then it will call for every movie detail.
        DispatchQueue.global().async {
            self.viewModel.fetchGenres()
        }
    }
    
    private func configureTableView() {
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
        tableView.rowHeight = UITableView.automaticDimension

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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
        case .loading, .loaded:
            tableView.reloadData()
        case .error:
            showError()
        }
        refreshControl?.endRefreshing()
    }

    private func showError() {
        self.displayAlert(message: LocalizedString(key: "movies.load.error.body"), actionTitle: LocalizedString(key: "movies.load.error.actionButton"))
    }

    // MARK: - Button Actions
    @objc private func refreshData() {
        viewModel.fetchData()
    }

    @objc private func textSizeChanged() {
        tableView.reloadData()
    }
    
    @objc func filterButtonTapped(_ sender: UIBarButtonItem) {
        let filterViewModel = FilterViewModel(_selectedGenres: viewModel.selectedGenres ?? [])
        let filterVC = FilterViewController(viewModel: filterViewModel)
        
        filterVC.delegate = self
        let nav = UINavigationController(rootViewController: filterVC)
        
        self.present(nav, animated: true)
    }
    
    // MARK: - Setup Searchbar
    private func setupSearchbar() {
        searchController = UISearchController(searchResultsController: SearchResultsTableViewController())
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        self.extendedLayoutIncludesOpaqueBars = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.setupSearchFields()
    }
    
    private func setupSearchFields() {
        guard let searachField = searchController?.searchBar.searchTextField else {return}
        searachField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.font: UIFont.Body.small, .foregroundColor: UIColor.Brand.popsicle40])
        searachField.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        searachField.borderStyle = .none
        searachField.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        searachField.layer.borderWidth = 1.0
        searachField.layer.cornerRadius = 8
        
        searchController?.searchBar.setupLeaftImage(UIImage(named: "Search"))
        searchController?.searchBar.barTintColor = .clear
        searchController?.searchBar.setImage(UIImage(named: "Filter"), for: .bookmark, state: .normal)
        searchController?.searchBar.showsBookmarkButton = true
        searchController?.searchBar.tintColor = UIColor.Brand.popsicle40
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dispatchItem?.cancel()
        guard let searchResultVC = searchController.searchResultsController as? SearchResultsTableViewController else { return}
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchResultVC.items = []
            return
        }

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else {return}
            self.viewModel.getSearchResults(for: searchText) { movies in
                DispatchQueue.main.async {
                    searchResultVC.items = []
                }
            }
        }
        
        dispatchItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5, execute: workItem)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("BookMark Button Clicked")
    }
}


// MARK: - UITableViewDataSource
extension MoviesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()

        let movie = viewModel.state.movies[indexPath.row]
        cell.configure(movie)

        return cell
    }
}

extension MoviesViewController: FilterVCDelegate {
    func setSelectedGenres(_ genres: [Section]) {
        viewModel.selectedGenres = genres
        viewModel.filterGenres(genres)
    }
}

// MARK: - UITableViewControllerDelegate
extension MoviesViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.state.movies[indexPath.row]
        let viewModel = MoviesDetailsViewModel(movie: movie, apiManager: APIManager())
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MoviesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
