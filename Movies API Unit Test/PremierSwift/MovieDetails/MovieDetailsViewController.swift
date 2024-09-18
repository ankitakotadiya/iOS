import UIKit

final class MovieDetailsViewController: UIViewController {

    private let viewModel: MoviesDetailsViewModel
    private(set) var currentViewController: UIViewController!

    init(viewModel: MoviesDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapBack(_:)))
        updateFromViewModel()
        bindViewModel()
        DispatchQueue.global().async {
            self.viewModel.updateUI()
        }
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
        let state = viewModel.state
        title = state.movieDetails?.title
        switch state {
        case .loading(let movie):
            self.showLoading(movie)
        case .loaded(let movieData):
            self.showMovieDetails(movieData.details, similarMovie: movieData.similarMovie)
        case .error:
            self.showError()
        }
    }

    private func showLoading(_ movie: Movie) {
        let loadingViewController = LoadingViewController()
        addChild(loadingViewController)
        loadingViewController.view.frame = view.bounds
        loadingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loadingViewController.view)
        loadingViewController.didMove(toParent: self)
        currentViewController = loadingViewController
    }
    
    // Since the half-screen layout is already configured using a child view controller, I have continued with this approach. In a larger project, it's important to follow standard practices for setting up views to avoid overloading the view controller. If I were to set up the view here, both APIs could be called in parallel, allowing us to display the top and bottom halves of the view based on their respective responses.
    private func showMovieDetails(_ movieDetails: MovieDetails, similarMovie: [Movie]) {
        let displayViewController = MovieDetailsDisplayViewController(movieDetails: movieDetails, movie: similarMovie)
        addChild(displayViewController)
        displayViewController.view.frame = view.bounds
        displayViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        currentViewController?.willMove(toParent: nil)
        transition(
            from: currentViewController,
            to: displayViewController,
            duration: 0.25,
            options: [.transitionCrossDissolve],
            animations: nil
        ) { (_) in
            self.currentViewController.removeFromParent()
            self.currentViewController = displayViewController
            self.currentViewController.didMove(toParent: self)
        }
    }

    private func showError() {
        self.displayAlert(message: LocalizedString(key: "moviedetails.load.error.body"), actionTitle: LocalizedString(key: "movies.load.error.actionButton"))
    }

    @objc private func didTapBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
