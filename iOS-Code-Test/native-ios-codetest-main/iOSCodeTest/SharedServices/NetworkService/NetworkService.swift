//
// Copyright © 2022 ASOS. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
	func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func fetch(url: URL) async throws -> Result<Data, Error>
}

// MARK: - URLDataTaskProvider

protocol URLDataTaskProvider {
	func dataTask(
		with url: URL,
		completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionDataTask
    
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLDataTaskProvider {}

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
	enum NetworkServiceError: Error {
		case invalidDataTaskResponse
	}

	private let urlDataTaskProvider: URLDataTaskProvider

	init(urlDataTaskProvider: URLDataTaskProvider = URLSession.shared) {
		self.urlDataTaskProvider = urlDataTaskProvider
	}

	func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		urlDataTaskProvider.dataTask(
			with: url,
			completionHandler: { data, _, error in
				guard let data = data else {
					completion(.failure(error ?? NetworkServiceError.invalidDataTaskResponse))
					return
				}
				DispatchQueue.main.async {
					completion(.success(data))
				}
			}
		).resume()
	}
    
    func fetch(url: URL) async throws -> Result<Data, Error> {
        do {
            let (data, _) = try await urlDataTaskProvider.data(from: url)
            return .success(data)
        } catch {
            return .failure(NetworkServiceError.invalidDataTaskResponse)
        }
    }
}
