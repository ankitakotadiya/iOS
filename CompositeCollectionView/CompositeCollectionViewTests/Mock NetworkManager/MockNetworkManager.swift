//
//  MockNetworkManager.swift
//  CompositeCollectionViewTests
//
//  Created by Ankita Kotadiya on 04/11/24.
//

import Foundation

final class MockNetworkManager: NetworkManaging {
    var iserror: Bool = false
    
    func fetchData<T>(_ request: Request<T>) async -> Result<T, NetworkError> where T : Decodable {
        
        if iserror {
            return .failure(.invalidURL)
        } else {
            if T.self == Page<Product>.self {
                return .success(Page.testPage as! T)
            } else {
                return .failure(.invalidURL)
            }
        }
    }
}
