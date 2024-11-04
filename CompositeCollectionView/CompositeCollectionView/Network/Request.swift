//
//  Request.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<T> {
    let method: Method
    let path: String
    let params: [String: String]
    
    init(method: Method, path: String, params: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }
}
