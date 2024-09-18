import UIKit

final class MoviesViewController: UITableViewController {
    
    private let viewModel: MoviesViewModel

    init(viewModel: MoviesViewModel) {
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

    @objc private func refreshData() {
        viewModel.fetchData()
    }

    @objc private func textSizeChanged() {
        tableView.reloadData()
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

// MARK: - UITableViewControllerDelegate
extension MoviesViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.state.movies[indexPath.row]
        let viewModel = MoviesDetailsViewModel(movie: movie, apiManager: APIManager())
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
