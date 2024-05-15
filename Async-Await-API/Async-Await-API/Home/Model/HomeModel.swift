//
//  HomeModel.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation

struct HomeModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
