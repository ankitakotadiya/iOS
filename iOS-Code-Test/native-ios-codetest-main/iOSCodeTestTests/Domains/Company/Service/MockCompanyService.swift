//
// Copyright © 2024 ASOS. All rights reserved.
//

import Foundation
@testable import iOSCodeTest

enum MockError: Error {
    case testError
}

class MockCompanyService: CompanyFetcher {
    
    var isError: Bool = false
    func fetchCompany(completion: @escaping (Result<Company, Error>) -> Void) {
        
    }
    
    func fetchCompany() async -> Result<Company, Error> {
        if isError {
            return .failure(MockError.testError)
        } else {
            return .success(Company.testValue)
        }
    }
}
