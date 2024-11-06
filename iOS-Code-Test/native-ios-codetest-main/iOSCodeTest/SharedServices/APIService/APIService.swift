//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

// MARK: - APIEndpoint

protocol APIEndpoint {
	associatedtype Response: Decodable

	var url: URL { get }
}

// MARK: - APIService

protocol APIServiceProtocol {
	func fetch<Endpoint: APIEndpoint>(
		from endpoint: Endpoint,
		completion: @escaping (Result<Endpoint.Response, Error>
	) -> Void)
    
    func fetchasync<Endpoint: APIEndpoint>(
        from endpoint: Endpoint
    ) async -> Result<Endpoint.Response, Error>
}

final class APIService: APIServiceProtocol {
	private let networkService: NetworkServiceProtocol
	private let jsonDecoder: JSONDecoder

	init(
		networkService: NetworkServiceProtocol = NetworkService(),
		jsonDecoder: JSONDecoder = JSONDecoder()
	) {
		self.networkService = networkService
		self.jsonDecoder = jsonDecoder
	}

	func fetch<Endpoint: APIEndpoint>(
		from endpoint: Endpoint,
		completion: @escaping (Result<Endpoint.Response, Error>) -> Void
	) {
		networkService.fetch(
			url: endpoint.url,
			completion: { [jsonDecoder] dataResult in
				let responseResult = Result<Endpoint.Response, Error> {
					let data = try dataResult.get()
					return try jsonDecoder.decode(Endpoint.Response.self, from: data)
				}
				completion(responseResult)
			}
		)
	}
    
    func fetchasync<Endpoint: APIEndpoint>(
        from endpoint: Endpoint
    ) async -> Result<Endpoint.Response, Error> {
        do {
            let response = try await networkService.fetch(url: endpoint.url)
            let data = try response.get()
            let jsonObject = try jsonDecoder.decode(Endpoint.Response.self, from: data)
            return .success(jsonObject)
        } catch {
            return .failure(error)
        }
    }
}
