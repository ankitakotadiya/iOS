//
//  Request.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<Value> {
    var method: Method
    var path: String
    var params: [String: String]
    
    init(method: Method, path: String, params: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }
}
