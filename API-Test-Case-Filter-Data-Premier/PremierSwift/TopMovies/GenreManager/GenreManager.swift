//
//  GenreManager.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation

protocol GenreManaging {
    func setGenres(_ genres: [Genre])
    func genreName(for id: Int) -> String
    var genresList: [Genre] {get set}
}

class GenreManager: GenreManaging {
    static let shared = GenreManager() // Singleton instance
    private init() {} // Prevents instantiation from outside
    
    private var genreDictionary: [Int: String] = [:]
    var genresList: [Genre] = []

    // Method to set genre data
    func setGenres(_ genres: [Genre]) {
        self.genresList = genres
        genreDictionary = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0.name) })
    }
    
    // Method to get genre name by ID
    func genreName(for id: Int) -> String {
        return genreDictionary[id] ?? ""
    }
}
