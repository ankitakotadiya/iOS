//
//  Page.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let products: [T]?
    let message: String?
}
