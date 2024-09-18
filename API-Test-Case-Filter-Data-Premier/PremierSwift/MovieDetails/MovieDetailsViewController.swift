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
    
    override func loadView() {
        view = MovieDetailsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapBack(_:)))
        setUpButtonActions()
        updateFromViewModel()
        bindViewModel()
        DispatchQueue.global().async {
            self.viewModel.updateUI()
        }
    }
    
    private lazy var contentView: MovieDetailsView? = {
        return self.view as? MovieDetailsView
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
        let state = viewModel.state
        title = state.movieDetails?.title
        switch state {
        case .loading(_):
            self.showIndicator()
//                        self.showLoading(movie)
        case .loaded(let movieDetails):
            self.hideIndicator()
            if let details = movieDetails.details {
                contentView?.configure(movieDetails: details)
            }
            contentView?.configureSimilarMovie(movie: movieDetails.similarMovie)
            
            //            self.showMovieDetails(movieData.details, similarMovie: movieData.similarMovie)
        case .error:
            self.hideIndicator()
            self.showError()
        }
    }
    
    private func setUpButtonActions() {
        contentView?.viewAllButton.addTarget(self, action: #selector(didTappedViewAll(_:)), for: .touchUpInside)
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
    
    @objc func didTappedViewAll(_ sender: UIButton) {
        let viewModel = ViewAllViewModel(initialMovie: viewModel.initialMovie)
        let movieVC = ViewAllMoviesViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(movieVC, animated: true)
    }

    @objc private func didTapBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("MovieDetails Deallocated")
    }
}

extension MovieDetailsViewController {
    
    private class MovieDetailsView: UIView {
        
        let scrollView = UIScrollView()
        let backdropImageView = UIImageView()
        let titleLabel = UILabel()
        let overviewLabel = UILabel()
        let similarMovieLabel = UILabel()
        let viewAllButton = UIButton()
        let movieHeaderStackView = UIStackView()
        // Similar movie view
        var similarView = SimilarMovieView<Movie, MovieCollectionViewCell>()
        private lazy var contentStackView = UIStackView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
//            commonInit()
        }
        
        private func commonInit() {
            setupViewsHierarchy()
            backgroundColor = .white
            
            backdropImageView.contentMode = .scaleAspectFill
            backdropImageView.clipsToBounds = true
            
            titleLabel.font = UIFont.Heading.medium
            titleLabel.textColor = UIColor.Text.charcoal
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.setContentHuggingPriority(.required, for: .vertical)
            
            overviewLabel.font = UIFont.Body.small
            overviewLabel.textColor = UIColor.Text.grey
            overviewLabel.numberOfLines = 0
            overviewLabel.lineBreakMode = .byWordWrapping
            
            similarMovieLabel.font = UIFont.Heading.xSmall
            similarMovieLabel.textColor = UIColor.Text.darkgrey
            similarMovieLabel.numberOfLines = 1
            similarMovieLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
            // I have created common button configuration that can be created for the other components to save time and reuse.
            viewAllButton.configure(font: UIFont.Body.small,
                                    titleColor: UIColor.Brand.popsicle40,
                                    tintColor: UIColor.Brand.popsicle40,
                                    semanticContentAttribute: .forceRightToLeft)
            viewAllButton.setTitleAndImageSpacing(8.0)
            viewAllButton.clipsToBounds = true
            
            movieHeaderStackView.axis = .horizontal
            movieHeaderStackView.alignment = .center
            movieHeaderStackView.spacing = 10
            
            contentStackView.axis = .vertical
            contentStackView.spacing = 24
            contentStackView.setCustomSpacing(8, after: titleLabel)
            contentStackView.setCustomSpacing(8, after: movieHeaderStackView)
            
            setupConstraints()
        }
        
        private func setupViewsHierarchy() {
            addSubview(scrollView)
            movieHeaderStackView.dm_addArrangedSubviews(similarMovieLabel,viewAllButton)
            contentStackView.dm_addArrangedSubviews(backdropImageView,titleLabel,overviewLabel,movieHeaderStackView, similarView)
            scrollView.addSubview(contentStackView)
        }
        
        private func setupConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            backdropImageView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            similarView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    
                    backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 11 / 16, constant: 0),
                    
                    // There's no need to specify constants here, as we have already set the constraints on the scroll view. Using `scrollView.topAnchor` directly is sufficient.
                    contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
                    contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
                    movieHeaderStackView.heightAnchor.constraint(equalToConstant: 40),
                    similarView.heightAnchor.constraint(equalToConstant: 302)
                ]
            )
            
            scrollView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
            preservesSuperviewLayoutMargins = false
        }
        
        func configure(movieDetails: MovieDetails) {
            backdropImageView.dm_setImage(backdropPath: movieDetails.backdropPath)
            titleLabel.text = movieDetails.title
            overviewLabel.text = movieDetails.overview
            similarMovieLabel.text = LocalizedString(key: "moviedetails.similarmovies.title")
            viewAllButton.configure(title: LocalizedString(key:"moviedetails.viewall.title"),
                imageName: Images.MovieDetails.arrowRight)
        }
        
        func configureSimilarMovie(movie: [Movie]) {
            similarView.updateMovies(movie)
        }
    }
}
