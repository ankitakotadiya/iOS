//
//  HomeModel.swift
//  DispatchGroup
//
//  Created by Ankita Kotadiya on 15/05/24.
//

import Foundation

struct Posts: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct User {
    let name: String
    let Address: String
}

struct UserDetails {
    let image: String
}
