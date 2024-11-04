//
//  Product.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let tags: [String]
    let brand: String?
    let sku: String?
    let images: [String]?
    let createdAt: String?
    
    var imgURLs: [URL]? {
        var urls: [URL] = []
        
        guard let strImages = images else {return nil}
        for strImg in strImages {
            if let url = URL(string: strImg) {
                urls.append(url)
            }
        }
        return urls
    }
}

extension Product {
    static var productList: Request<Page<Product>> {
        return Request(method: .get, path: "products")
    }
}
