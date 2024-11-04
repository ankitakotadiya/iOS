//
//  NetworkManager.swift
//  CompositeCollectionView
//
//  Created by Ankita Kotadiya on 03/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}
protocol NetworkManaging {
    func fetchData<T: Decodable>(_ request: Request<T>) async -> Result<T, NetworkError>
}

class NetworkManager: NetworkManaging {
    let host = "https://dummyjson.com/"
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchData<T>(_ request: Request<T>) async -> Result<T, NetworkError> where T : Decodable {
        do {
            let _urlRequest = try urlRequest(_request: request)
            let (data, _) = try await urlSession.data(for: _urlRequest)
            
            let jsonData = try JSONDecoder().decode(T.self, from: data)
            return .success(jsonData)
        } catch {
            return .failure(.invalidURL)
        }
    }
    
    private func urlRequest<T: Decodable>(_request: Request<T>) throws -> URLRequest {
        guard let url = URL(string: host)?.appendingPathComponent(_request.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = _request.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return request
    }
    
    
}
