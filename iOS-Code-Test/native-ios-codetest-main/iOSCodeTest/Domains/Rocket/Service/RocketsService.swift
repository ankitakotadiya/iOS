//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

protocol RocketsFetcher {
	func fetchRockets(completion: @escaping (Result<[Rocket], Error>) -> Void)
    func fetchRockets() async -> Result<[Rocket], Error>
}

struct RocketsAPIEndpoint: APIEndpoint {
	typealias Response = [Rocket]

	let url = URL(string: "https://api.spacexdata.com/v4/rockets")!
}

final class RocketsService: RocketsFetcher {
	private let apiService: APIServiceProtocol

	init(apiService: APIServiceProtocol = APIService()) {
		self.apiService = apiService
	}

	func fetchRockets(completion: @escaping (Result<[Rocket], Error>) -> Void) {
		let endpoint = RocketsAPIEndpoint()
		apiService.fetch(from: endpoint, completion: completion)
	}
    
    func fetchRockets() async -> Result<[Rocket], Error> {
        let endpoint = RocketsAPIEndpoint()
        return await apiService.fetchasync(from: endpoint)
//        return await withCheckedContinuation { continuation in
//            apiService.fetch(from: endpoint) { result in
//                continuation.resume(returning: result)
//            }
//        }
    }
}
