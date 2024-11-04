//
//  ProductTestValue.swift
//  CompositeCollectionViewTests
//
//  Created by Ankita Kotadiya on 04/11/24.
//

import Foundation

extension Page where T == Product {
    static let testPage = Page(products: [Product.value])
}

extension Product {
    static let value = Product(
        id: 0,
        title: "Test Product1",
        description: "Test Product Description",
        category: "beauty",
        price: 12.50,
        discountPercentage: 1.89,
        rating: 4.5,
        tags: ["beauty"],
        brand: "MAC",
        sku: "Test123",
        images: ["images://"],
        createdAt: "04-11-2024"
    )
}
