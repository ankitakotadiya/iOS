//
//  DependencyManager.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 28/10/24.
//

import Foundation


struct DependencyManager {

    static var networkManager: NetworkManaging {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            return MockNetworkManager()
        }
        return NetworkManager()
    }
    
}
