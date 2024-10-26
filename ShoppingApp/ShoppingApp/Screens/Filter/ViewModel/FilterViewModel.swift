//
//  FilterViewModel.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import Foundation
import Combine

final class FilterViewModel {
    @Published var Filters: [Filter]?
    var savedFilter: [Filter]
    
    init(savedFilter: [Filter]) {
        self.savedFilter = savedFilter
    }
    
    func getDefaultFilter() -> [Filter] {
        return [
            Filter(title: .date, values: [SubFilter(id: "all", title: "All", isSelected: true)], isSelected: false),
            Filter(title: .brand, values: [SubFilter(id: "all", title: "All", isSelected: true)], isSelected: false),
            Filter(title: .category, values: [SubFilter(id: "all", title: "All", isSelected: true)], isSelected: false),
            Filter(title: .price, values: [SubFilter(id: "all", title: "All", isSelected: true)], isSelected: false)
        ]
    }
    
    func setFilter(type: Titles, subFilters: [SubFilter]) {
        if let index = Filters?.firstIndex(where: { $0.title == type }) {
            // Update the values of the matching filter with the new subFilters
            Filters?[index].values = subFilters
            Filters?[index].isSelected = subFilters.contains(where: {$0.id != "all"})
            
            if let savedFilterIndex = savedFilter.firstIndex(where: {$0.title == type}) {
                savedFilter[savedFilterIndex].isSelected = subFilters.contains(where: {$0.id != "all"})
                savedFilter[savedFilterIndex].values = subFilters
            }
        }
    }
    
    func createDefaultFilter() {
        var filters = getDefaultFilter()
        
        for filter in savedFilter {
            if let index = filters.firstIndex(where: {$0.title == filter.title}) {
                filters[index].values = filter.values
                filters[index].isSelected = filter.isSelected
            }
        }
        
        Filters = filters
    }
    
    func clearFilter() {
        Filters = getDefaultFilter()
    }
    
    var selectedFilter: [Filter] {
        let filters = Filters
        return filters?.filter({$0.isSelected}) ?? []
    }
}
