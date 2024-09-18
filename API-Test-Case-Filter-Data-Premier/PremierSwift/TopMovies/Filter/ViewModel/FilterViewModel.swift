//
//  FilterViewModel.swift
//  PremierSwift
//
//  Created by Ankita Kotadiya on 11/09/24.
//  Copyright © 2024 Deliveroo. All rights reserved.
//

import Foundation
import Combine

enum Titles: String {
    case genres = "Genres"
    case ratings = "Ratings"
}
struct Section {
    let title: Titles
    var items: [FilterItems]
}

struct FilterItems: Equatable {
    static func == (lhs: FilterItems, rhs: FilterItems) -> Bool {
        if lhs.id == rhs.id && lhs.name == rhs.name {
            return true
        }
        return false
    }
    
    let id: Int
    let name: String
    var isSelected: Bool
}

class FilterViewModel {
    
    private let apiManager: APIManaging
    private let genreManager: GenreManaging
    @Published var sections: [Section]?
    var selectedGenres: [Section] = []
    var genres: [Genre] = []
    var onSelect: (([Genre]) -> Void)?
    
    init(apiManager: APIManaging = APIManager(), genreManager: GenreManaging = GenreManager.shared, _selectedGenres: [Section]) {
        self.apiManager = apiManager
        self.genreManager = genreManager
        self.selectedGenres = _selectedGenres
    }
    
    func getGeneres() {
        if !self.genreManager.genresList.isEmpty {
            self.genres = self.genreManager.genresList
            self.loadSections()
        } else {
            // Call api and get the genres list
        }
    }
    
    func loadSections() {
        let genresItems = genres.map { genre in
            FilterItems(id: genre.id, name: genre.name, isSelected: isGenreSelected(genre))
        }
        
        let genreSection = Section(title: .genres, items: genresItems)
        
        let ratings = ["1-3", "3-5", "5-8", "8-10"]
        let ratingsItems = ratings.enumerated().map { (indx,item) in
            return FilterItems(id: indx, name: item, isSelected: isRatingSelected(item))
        }
        let ratingSection = Section(title: .ratings, items: ratingsItems)
        
        self.sections = [ratingSection, genreSection]
    }
    
    private func isGenreSelected(_ genre: Genre) -> Bool {
        return selectedGenres.first(where: {$0.title == .genres})?.items.contains{$0.id == genre.id && $0.isSelected == true} ?? false
    }
    
    private func isRatingSelected(_ rating: String) -> Bool {
        return selectedGenres.first(where: { $0.title == .ratings })?.items.contains { $0.name == rating && $0.isSelected == true} ?? false
    }
    
    func toggleSection(for filterItem: FilterItems, in section: Titles) {
        if let index = sections?.firstIndex(where: {$0.title == section}) {
            if let itemIndex = sections?[index].items.firstIndex(where: {$0.id == filterItem.id}) {
                sections?[index].items[itemIndex].isSelected.toggle()
            }
        }
    }
    
    func applyFilters() -> [Section] {
        selectedGenres = sections?.filter({ section in
            section.items.contains(where: {$0.isSelected})
        }) ?? []
        return selectedGenres
    }
    
    func clearAllFilter() {
        for secIndex in 0..<(sections?.count ?? 0){
            for index in 0..<(sections?[secIndex].items.count ?? 0) {
                sections?[secIndex].items[index].isSelected = false
            }
        }
        selectedGenres.removeAll()
    }
}
