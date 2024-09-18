import UIKit

final class MovieDetailsDisplayViewController: UIViewController {
    
    let movieDetails: MovieDetails
    let movie: [Movie]
    
    init(movieDetails: MovieDetails, movie: [Movie]) {
        self.movieDetails = movieDetails
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let customeView = view as? View {
            customeView.configure(movieDetails: movieDetails)
            customeView.configureSimilarMovie(movie: movie)
        }
    }
    
    private class View: UIView {
        
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
            commonInit()
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
                                    title: LocalizedString(key: "moviedetails.viewall.title"),
                                    imageName: Images.MovieDetails.arrowRight,
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
        }
        
        func configureSimilarMovie(movie: [Movie]) {
            similarView.updateMovies(movie)
        }
    }
}

