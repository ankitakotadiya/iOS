import Foundation

enum MoviesViewModelState {
    case loading
    case loaded([Movie])
    case error

    var movies: [Movie] {
        switch self {
        case .loaded(let movies):
            return movies
        case .loading, .error:
            return []
        }
    }
}

final class MoviesViewModel {

    private let apiManager: APIManaging
    private let genreManager: GenreManaging

    init(apiManager: APIManaging = APIManager(), genreManager: GenreManaging = GenreManager.shared) {
        self.apiManager = apiManager
        self.genreManager = genreManager
    }

    var updatedState: (() -> Void)?

    var state: MoviesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }

    func fetchData() {
        apiManager.execute(Movie.topRated) { [weak self] result in
            switch result {
            case .success(let page):
                self?.state = .loaded(page.results)
            case .failure:
                self?.state = .error
            }
        }
    }
    
    // Fetch Genre List
    func fetchGenres() {
        apiManager.execute(Genres.genrelist) { [weak self] result in
            switch result {
            case .success(let genres):
                self?.genreManager.setGenres(genres.genres)
            case .failure:
                self?.genreManager.setGenres([])
            }
        }
    }
}
