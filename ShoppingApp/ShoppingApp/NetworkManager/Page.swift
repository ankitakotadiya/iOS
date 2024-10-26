//
//  Page.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let products: [T]
}
