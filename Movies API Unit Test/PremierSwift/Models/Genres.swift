//
//  Genre.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    
    let id: Int
    let name: String
}

struct Genres: Decodable {
    let genres: [Genre]
}

// Extension to define movie-related requests.
extension Genres {
    static var genrelist: Request<Genres> {
        return Request(method: .get, path: "/genre/movie/list")
    }
}
