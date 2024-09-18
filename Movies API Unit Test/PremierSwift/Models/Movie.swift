import Foundation

struct Movie: Decodable {
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
}

// Extension to define movie-related requests.
extension Movie {
    static var topRated: Request<Page<Movie>> {
        return Request(method: .get, path: "/movie/top_rated")
    }
    
    static func similarMovie(for movie: Movie) -> Request<Page<Movie>> {
        return Request(method: .get, path: "/movie/\(movie.id)/similar")
    }
}
