//
//  Product.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
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
            urls.append(URL(string: strImg)!)
        }
        return urls
    }
}

extension Product {
    static var productList: Request<Page<Product>> {
        return Request(method: .get, path: "products")
    }
}
