import Foundation

enum MoviesViewModelState: Equatable {
    static func == (lhs: MoviesViewModelState, rhs: MoviesViewModelState) -> Bool {
        return true
    }
    
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

protocol MoviesViewModelProvider: AnyObject {
    var updatedState: (() -> Void)? {get set}
    var state: MoviesViewModelState {get set}
    func fetchData()
    func fetchGenres()
    func filterGenres(_ genres: [Section])
    var selectedGenres: [Section]? {get set}
    func getSearchResults(for searchTerm: String, completion: @escaping ([Movie]) -> Void)
}

final class MoviesViewModel: MoviesViewModelProvider {
    private let apiManager: APIManaging
    private let genreManager: GenreManaging

    init(apiManager: APIManaging = APIManager(), genreManager: GenreManaging = GenreManager.shared) {
        self.apiManager = apiManager
        self.genreManager = genreManager
    }
    
    private var tempMovies: [Movie] = []
    var selectedGenres: [Section]?

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
                self?.tempMovies = page.results
                self?.filterGenres([])
//                self?.state = .loaded(page.results)
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
    
    // Filter Genres wise
    func filterGenres(_ genres: [Section]) {
        if genres.count > 0 {
            if let index = genres.firstIndex(where: {$0.title == .genres}) {
                let genreIds = genres[index].items.filter({$0.isSelected}).map { $0.id }
                let filteredMovies = self.tempMovies.filter { movie in
                    movie.genreIds.contains { genreIds.contains($0) }
                }
                self.state = .loaded(filteredMovies)
            }
        } else {
            self.state = .loaded(tempMovies)
        }
    }
    
    // Fetch SearchResults
    func getSearchResults(for searchTerm: String, completion: @escaping ([Movie]) -> Void) {
        let request = Request<Page<Movie>>(method: Method.get, path: "/search/movie", _queryParams: ["query": searchTerm])
        apiManager.execute(request, completion: { result in
            if case .success(let page) = result {
                completion(page.results)
            }
        })
    }
}
