import Foundation

enum MoviesDetailsViewModelState: Equatable {
    static func == (lhs: MoviesDetailsViewModelState, rhs: MoviesDetailsViewModelState) -> Bool {
        return true
    }
    
    case loading(Movie)
    case loaded((details: MovieDetails, similarMovie: [Movie]))
    case error

    var title: String? {
        switch self {
        case .loaded(let movieData):
            return movieData.details.title
        case .loading(let movie):
            return movie.title
        case .error:
            return nil
        }
    }

    var movieDetails: MovieDetails? {
        switch self {
        case .loaded(let movieData):
            return movieData.details
        case .loading, .error:
            return nil
        }
    }
    
    var movie: [Movie]? {
        switch self {
        case .loaded(let movieData):
            return movieData.similarMovie
        case .loading, .error:
            return []
        }
    }
}

final class MoviesDetailsViewModel {

    private let apiManager: APIManaging
    private let initialMovie: Movie
    var movieDetail: MovieDetails?
    var similarMovie: [Movie]?
    private let dispatchGroup: DispatchGroup = DispatchGroup()

    // Initializer with movie and API manager.
    init(movie: Movie, apiManager: APIManaging = APIManager()) {
        self.initialMovie = movie
        self.apiManager = apiManager
        self.state = .loading(movie)
    }
    // Closure that will be called when the state changes.
    var updatedState: (() -> Void)?

    // The current state of the view model.
    var state: MoviesDetailsViewModelState {
        didSet {
            updatedState?()
        }
    }
    
    // Fetch movie details.
    func fetchData() {
        dispatchGroup.enter()
        apiManager.execute(MovieDetails.details(for: initialMovie)) { [weak self] result in
            defer {self?.dispatchGroup.leave()}
            guard let self = self else { return }
            switch result {
            case .success(let movieDetails):
                self.movieDetail = movieDetails
            case .failure:
                self.state = .error
            }
        }
    }
    
    // Fetch similar movies.
    func fetchSimilarMovie() {
        dispatchGroup.enter()
        apiManager.execute(Movie.similarMovie(for: initialMovie)) { [weak self] result in
            defer {self?.dispatchGroup.leave()}
            guard let self = self else {return}
            switch result {
            case .success(let page):
                self.similarMovie = page.results
            case .failure:
                self.state = .error
            }
        }
    }
    
    // Update UI by fetching data and similar movies, then updating state.
    func updateUI() {
        self.fetchData()
        self.fetchSimilarMovie()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            if let details = self.movieDetail, let movies = self.similarMovie {
                self.state = .loaded((details: details, similarMovie: movies))
            } else {
                self.state = .error
            }
        }
    }
}
