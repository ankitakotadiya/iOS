//
//  LoginModel.swift
//  LoginSignup-TestCase
//
//  Created by Ankita Kotadiya on 10/06/24.
//

import Foundation


struct User: Codable {
    let id: Int
    let name: String
    // Add other properties as needed

    // Mock initializer for testing
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
