//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

protocol CompanyFetcher {
	func fetchCompany(completion: @escaping (Result<Company, Error>) -> Void)
    func fetchCompany() async -> Result<Company, Error>
}

enum CompanyResult {
    case success(Company)
    case failure(Error)
}

struct CompanyAPIEndpoint: APIEndpoint {
	typealias Response = Company

	let url = URL(string: "https://api.spacexdata.com/v4/company")!
}

final class CompanyService: CompanyFetcher {
	private let apiService: APIServiceProtocol

	init(apiService: APIServiceProtocol = APIService()) {
		self.apiService = apiService
	}

	func fetchCompany(completion: @escaping (Result<Company, Error>) -> Void) {
		let endpoint = CompanyAPIEndpoint()
		apiService.fetch(from: endpoint, completion: completion)
	}
    
    func fetchCompany() async -> Result<Company, Error> {
        let endpoint = CompanyAPIEndpoint()
        return await apiService.fetchasync(from: endpoint)
        
        //        return await withCheckedContinuation { continuation in
//            apiService.fetch(from: endpoint) { result in
//                continuation.resume(returning: result)
//            }
//        }
    }
}
