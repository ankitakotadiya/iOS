//
//  SubFilterViewModel.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import Foundation

final class SubFilterViewModel {
    @Published var subFilters: [SubFilter] = []
    let type: Titles
    var selectedValues: [SubFilter]
    var selectedCount = 0
    
    init(type: Titles, selectedValues: [SubFilter]) {
        self.type = type
        self.selectedValues = selectedValues
    }
    
    var filterItems: [String] {
        switch type {
        case .date:
            return ["Today", "Yesterday", "Last 7 Days"]
        case .brand:
            return ["Essence", "Glamour Beauty", "Velvet Touch", "Chic Cosmetics", "Nail Couture", "Calvin Klein", "Chanel", "Dior", "Dolce & Gabbana", "Gucci", "Annibale Colombo", "Furniture Co.", "Knoll", "Bath Trends"]
        case .category:
            return ["Beauty", "Fragrances", "Furniture", "Groceries"]
        case .price:
            return [] // Handle price case if needed
        }
    }
    
    func createSubFilter() {
        let selectedFilter = selectedValues.map({$0.title})
        
        subFilters = filterItems.map({ item in
            
            let isSelected = selectedFilter.contains(item)
            let id = (type == .brand) ? item : item.lowercased()
            
            return SubFilter(id: id, title: item, isSelected: isSelected)
        })
    }
    
    func clearFilter() {
        selectedValues = []
        createSubFilter()
        selectedCount = 0
    }
    
    func allFilterSelected() {
        subFilters = filterItems.map({ item in
            
            let id = (type == .brand) ? item : item.lowercased()
            
            return SubFilter(id: id, title: item, isSelected: true)
        })
        selectedCount = subFilters.count
    }
    
    var selectedFilterItems: [SubFilter]  {
        let selectedValues = self.subFilters.filter({ $0.isSelected })
        
        if selectedValues.count == 0 || selectedValues.count == subFilters.count {
            return [SubFilter(id: "all", title: "All", isSelected: false)]
        } else {
            return selectedValues
        }
    }
}
