//
// Copyright © 2024 ASOS. All rights reserved.
//

import Foundation
@testable import iOSCodeTest

class MockLaunchService: LaunchesFetcher {
    func fetchLaunches(completion: @escaping (Result<[iOSCodeTest.Launch], Error>) -> Void) {
        
    }
    
    func fetchLaunches() async -> Result<[Launch], Error> {
        return .success([Launch.testValue])
    }
    
    
}
