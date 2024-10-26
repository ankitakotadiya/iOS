//
//  Request.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation

enum Method: String {
    case get = "GET"
}
struct Request<Value> {
    let method: Method
    let path: String
    let params: [String: String]
    
    init(method: Method, path: String, params: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }
}
