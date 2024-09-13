//
//  MockNetworkManager.swift
//  HeadlinesTests
//
//  Created by Ankita Kotadiya on 02/09/24.
//  Copyright © 2024 Example. All rights reserved.
//

import Foundation
@testable import Headlines

enum MockError: Error, LocalizedError {
    case invalidResponse
    case invalidData
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server."
        case .customError(let message):
            return message
        case .invalidData:
            return "Not able to parse data."
        }
    }
}

protocol KeyIdentifiable {
    static var key: String { get }
}

struct ResponseData<T: Decodable>: Decodable {
    let results: [T]
}

class MockNetworkManager: NetworkManagerProvider {
    var shouldReturnError = false
    private var mockData: Any?
    
    
    func setMockData<T: Decodable>(for type: T.Type, jsonString: String) {
        if let data = self.decodeJSON(type, from: jsonString) {
            self.mockData = data
        }
    }
    
    func decodeJSON<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            return nil
        }
    }
    
    func execute<T>(request: RequestData<T>, completion: @escaping ((T?, Error?) -> Void)) where T : Decodable {
        if shouldReturnError {
            completion(nil, MockError.invalidResponse)
        } else {
            if let response = mockData as? T {
                completion(response, nil)
            }
        }
    }
}
