//
//  MockAPIManager.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
@testable import PremierSwift


class MockAPIManager: APIManaging {
    
    var isError: Bool = false
    
    let movieDetailsJson: String = {
        return """
        {
            "title": "Test Movie Detail",
            "overview": "Test Movie Detail Overview",
            "backdrop_path": "/path",
            "tagline": "Test Tagline"
        }
"""
    }()
    
    let movieJson: String = {
        return """
    {
        "page": 1,
        "total_pages": 10,
        "total_results": 100,
        "results": [
            {
            "id": 1,
            "poster_path": "/path",
            "title": "Test Movie",
            "overview": "Test Overview",
            "vote_average": 5.0,
            "genre_ids": [1,2],
            "backdrop_path": "/backdrop"
        }
    ]
}
"""
    }()
    
    let genresJson: String = {
        return """
        {
            "genres": [
                {
                    "id": 1,
                    "name": "Action"
                },
                {
                    "id": 2,
                    "name": "Drama"
                }
            ]
        }
"""
    }()
    
    func getJsonString<T: Decodable>(type: T.Type) -> String {
        
        if type == MovieDetails.self {
            return movieDetailsJson
        } else if type == Page<Movie>.self {
            return movieJson
        } else if type == Genres.self {
            return genresJson
        } else {
            return ""
        }
    }
    
    func decodeJson<T: Decodable>(type: T.Type, jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else {return nil}
        
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            fatalError("Data is not able to parse: \(error.localizedDescription)")
        }
    }
    
    func execute<Value>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) where Value : Decodable {
        
        if isError {
            completion(.failure(.networkError))
        } else {
            if let jsonObject = self.decodeJson(type: Value.self, jsonString: self.getJsonString(type: Value.self)) {
                completion(.success(jsonObject))
            } else {
                completion(.failure(.parsingError))
            }
        }
    }
}

enum MockError: Error {
    case networkError
    case parsingError
}


//class MockAPIManager: APIManaging {
//    
//    var movieDetailsResult: Result<MovieDetails, APIError>?
//    var similarMoviesResult: Result<Page<Movie>, APIError>?
//    var genreResult: Result<Genres, APIError>?
//
//    func execute<Value>(_ request: PremierSwift.Request<Value>, completion: @escaping (Result<Value, PremierSwift.APIError>) -> Void) where Value : Decodable {
//        if let result = movieDetailsResult as? Result<Value, APIError> {
//            completion(result)
//        }
//        if let result = similarMoviesResult as? Result<Value, APIError> {
//            completion(result)
//        }
//        if let result = genreResult as? Result<Value, APIError> {
//            completion(result)
//        }
//    }
//}
//
//enum MockError: Error {
//    case networkError
//}
