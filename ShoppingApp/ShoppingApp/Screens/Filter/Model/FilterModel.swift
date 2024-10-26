//
//  FilterModel.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import Foundation

enum Titles: String {
    case date = "New In Date"
    case brand = "Brand"
    case category = "Category"
    case price = "Price"
}

struct Filter {
    let title: Titles
    var values: [SubFilter]
    var isSelected: Bool
}

struct SubFilter {
    let id: String
    let title: String
    var isSelected: Bool
}
