//
// Copyright © 2024 ASOS. All rights reserved.
//

import Foundation
@testable import iOSCodeTest

class MockRocketService: RocketsFetcher {
    func fetchRockets(completion: @escaping (Result<[iOSCodeTest.Rocket], Error>) -> Void) {
        
    }
    
    func fetchRockets() async -> Result<[iOSCodeTest.Rocket], Error> {
        return .success([Rocket.testValue])
    }
    
    
}
