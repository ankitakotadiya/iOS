//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

protocol LaunchesFetcher {
	func fetchLaunches(completion: @escaping (Result<[Launch], Error>) -> Void)
    func fetchLaunches() async -> Result<[Launch], Error>
}

struct LaunchesAPIEndpoint: APIEndpoint {
	typealias Response = [Launch]

	let url = URL(string: "https://api.spacexdata.com/v4/launches")!
}

final class LaunchesService: LaunchesFetcher {
	private let apiService: APIServiceProtocol

	init(apiService: APIServiceProtocol = APIService()) {
		self.apiService = apiService
	}

	func fetchLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
		let endpoint = LaunchesAPIEndpoint()
		apiService.fetch(from: endpoint, completion: completion)
	}
    
    func fetchLaunches() async -> Result<[Launch], Error> {
        let endpoint = LaunchesAPIEndpoint()
//        return await apiService.fetchasync(from: endpoint)
        return await withCheckedContinuation { continuation in
            apiService.fetch(from: endpoint) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
