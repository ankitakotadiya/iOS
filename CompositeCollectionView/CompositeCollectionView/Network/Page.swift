//
//  Page.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let products: [T]
}
