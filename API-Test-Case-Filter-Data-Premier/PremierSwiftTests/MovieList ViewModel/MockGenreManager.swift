//
//  MockGenreManager.swift
//  PremierSwiftTests
//
//  Created by Ankita Kotadiya on 18/08/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
@testable import PremierSwift

class MockGenreManager: GenreManaging {
    var genresList: [Genre] = []
    
    var genreDictionary: [Int: String] = [:]
    
    func setGenres(_ genres: [Genre]) {
        genreDictionary = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0.name) })
    }
    
    func genreName(for id: Int) -> String {
        return genreDictionary[id] ?? ""
    }
}

