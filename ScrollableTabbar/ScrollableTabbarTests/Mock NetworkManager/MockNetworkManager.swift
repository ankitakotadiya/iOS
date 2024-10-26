//
//  MockNetworkManager.swift
//  ScrollableTabbarTests
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation
@testable import ScrollableTabbar

final class MockNetworkManager: NetworkManaging {
    var isError: Bool = false
    
    private let productJson: String = {
        return """
    {
        "products": [
            {
            "id": 1,
            "title": "Test Product1",
            "category": "beauty",
            "description": "Test Description",
            "price": 23.23,
            "discountPercentage": 25.5,
            "rating": 3.5,
            "tags": [""],
            "brand": "Test Brand",
            "sku": "Test_SKU",
            "images": [""],
            "createdAt": ""
        }
    ]
}
"""
    }()
    
    private func getJson<T: Decodable>(of type: T.Type) -> String {
        if type == Page<Product>.self {
            return productJson
        }
        return ""
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            fatalError("Data is not able to parse: \(error.localizedDescription)")
        }
    }
    
    func execute<Value>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) where Value: Decodable{
        if isError {
            completion(.failure(.networkError))
        } else {
            if let jsonObject = self.decodeJson(type: Value.self, jsonString: self.getJson(of: Value.self)) {
                completion(.success(jsonObject))
            } else {
                completion(.failure(.networkError))
            }
        }
    }
}

enum MockError: Error {
    case networkError
    case parsingError
}
