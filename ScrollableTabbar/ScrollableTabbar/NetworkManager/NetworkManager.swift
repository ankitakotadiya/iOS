//
//  File.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidData
    case networkError
}
protocol NetworkManaging {
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result <Value, APIError>) -> Void)
}

final class NetworkManager: NetworkManaging {
    
    private let urlSession: URLSession
    let host = "https://dummyjson.com/"
    
    init(_session: URLSession = .shared) {
        urlSession = _session
    }
    
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        let urlrequest: URLRequest
        
        do {
            urlrequest = try urlRequest(for: request)
        } catch {
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: urlrequest) { responseData, response, _ in
            
            if let data = responseData {
                do {
                    let response = try JSONDecoder().decode(Value.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.invalidData))
                    return
                }
            } else {
                completion(.failure(.networkError))
            }
            
        }.resume()
    }
    
    private func urlRequest<Value>(for request: Request<Value>) throws -> URLRequest {
        guard let url = URL(host, request) else {
            throw APIError.invalidURL
        }
        
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.cachePolicy = .reloadRevalidatingCacheData
        return result
    }
}

extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var existingComponents: [URLQueryItem] = components?.queryItems ?? []
        existingComponents.append(contentsOf: queryItems)
        
        if existingComponents.count > 0 {
            components?.queryItems = existingComponents
        }
        
        return components?.url
    }
    
    init?<Value>(_ host: String, _ request: Request<Value>) {
        let queryItems = request.params.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let baseURL = URL(string: host) else {return nil}
        
        let urlPath = baseURL.appendingPathComponent(request.path).url(with: queryItems)
        
        guard let urlString = urlPath?.absoluteString else {return nil}
        
        self.init(string: urlString)
    }
}
