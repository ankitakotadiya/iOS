//
//  NetworkManager.swift
//  API-Combine
//
//  Created by Ankita Kotadiya on 13/05/24.
//

import Foundation
import Combine


enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

protocol NetworkManagerProtocol: AnyObject {
    
    func fetchData<T: Decodable>(url: Path, queryParams: [String: String], method: HttpMethod, bodyParams: [String: Any], type: T.Type) -> Future<[T], DataError>
    
    func fetchAsyncData<T: Decodable>(url: Path, queryParams: [String: String], method: HttpMethod, bodyParams: [String: Any], type: T.Type) async throws -> [T]
}

class NetworkManager: NetworkManagerProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchAsyncData<T: Decodable>(url: Path, queryParams: [String: String], method: HttpMethod, bodyParams: [String: Any], type: T.Type) async throws -> [T] {
        guard var urlComponents = URLComponents(string: url.rawValue) else {
            throw DataError.invalidURL
        }
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in queryParams {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        guard let requestUrl = urlComponents.url else {
            throw DataError.invalidURL
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue
        
        for (key, value) in API.commonHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if !bodyParams.isEmpty {
            let json = try JSONSerialization.data(withJSONObject: bodyParams, options: .fragmentsAllowed)
            urlRequest.httpBody = json
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            let userData = try JSONDecoder().decode([T].self, from: data)
            return userData
        } catch {
            throw DataError.invalidData
        }
    }
    
    func fetchData<T: Decodable>(url: Path, queryParams: [String: String], method: HttpMethod, bodyParams: [String: Any], type: T.Type) -> Future<[T], DataError> {
        return Future<[T], DataError> {[weak self] promise in
            
            guard var UrlComponents = URLComponents(string: url.rawValue) else {
                promise(.failure(.invalidURL))
                return }
            
            var queryItems = [URLQueryItem]()
            
            for (key,value) in queryParams {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
            
            if queryParams.count > 0 {
                UrlComponents.queryItems = queryItems
            }
            
            guard let requestUrl = UrlComponents.url else {
                promise(.failure(.invalidURL))
                return}
            var urlRequest = URLRequest(url: requestUrl)
            urlRequest.httpMethod = method.rawValue
            
            for (key,value) in API.commonHeaders {
                urlRequest.setValue(key, forHTTPHeaderField: value)
            }
            
            if bodyParams.count > 0 {
                if let json = try? JSONSerialization.data(withJSONObject: bodyParams, options: .fragmentsAllowed){
                    urlRequest.httpBody = json
                }
            }
            
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    
                    if let res = response as? HTTPURLResponse {
                        print(res.statusCode)
                    }
                    return data
                }.receive(on: RunLoop.main)
                .decode(type: [T].self, decoder: JSONDecoder())
                .sink { completion in
                    
                    switch completion {
                    case .failure(let dataError):
                        promise(.failure(.invalidData))
                        
                    case .finished:
                        break
                    }
                } receiveValue: { userData in
                    promise(.success(userData))
                }.store(in: &(self!.cancellable))
        }
    }
}
