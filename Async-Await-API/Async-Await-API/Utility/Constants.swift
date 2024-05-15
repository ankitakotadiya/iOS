//
//  Constants.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation

struct API {
    static let baseURL = "https://jsonplaceholder.typicode.com/"
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}

enum Path: String {
    case home
    
    var rawValue: String {
        switch self {
            
        case .home:
            return API.baseURL + "posts?"
        }
    }
}
