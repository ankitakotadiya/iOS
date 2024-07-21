//
//  NetworkManager.swift
//  API-Race-Test
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case decodingFailed
    case requestFailed
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkManagerProtocol: AnyObject {
    func callAsyncAPI<T: Decodable>(url: String, queryParams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type) async throws -> [T]
    func callCombineAPI<T: Decodable>(url: String, queryParams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type) -> Future<[T], NetworkError>
    
    func callCombineAnyPublisher<T: Decodable>(url: String, queryParams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type) -> AnyPublisher<[T], NetworkError>
    
    func traditionalApiCall<T: Decodable>(url: String, queryparams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type, completion: @escaping(Result<[T], NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol{
    
    func callCombineAnyPublisher<T>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: HTTPMethod, type: T.Type) -> AnyPublisher<[T], NetworkError> where T : Decodable {
        
        guard var urlComponents = URLComponents(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        if !queryParams.isEmpty {
            var queryItems = [URLQueryItem]()
            for (key,value) in queryParams {
                let quey = URLQueryItem(name: key, value: value)
                queryItems.append(quey)
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let URL = URL(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue
        
        if bodyParams.count > 0 {
            let bodyData = try? JSONSerialization.data(withJSONObject: bodyParams)
            request.httpBody = bodyData
        }
        
        for (key,value) in API.combineHeader {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResonse = response as? HTTPURLResponse, (200...209).contains(httpResonse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [T].self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return .decodingFailed
                } else {
                    return .requestFailed
                }
            }.eraseToAnyPublisher()
    }
    
    func callCombineAPI<T: Decodable>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: HTTPMethod, type: T.Type) -> Future<[T], NetworkError> {
        
        return Future<[T], NetworkError> {[weak self] promise in
            
            guard let self = self else {
                return
            }
            
            guard var urlComponents = URLComponents(string: url) else {
                promise(.failure(.invalidURL))
                return
            }
            
            if !queryParams.isEmpty {
                var queryItems = [URLQueryItem]()
                for (key,value) in queryParams {
                    let quey = URLQueryItem(name: key, value: value)
                    queryItems.append(quey)
                }
                urlComponents.queryItems = queryItems
            }
            
            guard let URL = URL(string: url) else {
                promise(.failure(.invalidURL))
                return
            }
            
            var request = URLRequest(url: URL)
            request.httpMethod = method.rawValue
            
            if bodyParams.count > 0 {
                let bodyData = try? JSONSerialization.data(withJSONObject: bodyParams)
                request.httpBody = bodyData
            }
            
            for (key,value) in API.combineHeader {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResonse = response as? HTTPURLResponse, (200...209).contains(httpResonse.statusCode) else {
                        throw NetworkError.invalidResponse
                    }
                    return data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: [T].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        promise(.failure(.invalidData))
                    }
                } receiveValue: { responseData in
                    promise(.success(responseData))
                }
                .store(in: &Cancellable.shared.set)
        }
    }
    
    // API Call
    func callAsyncAPI<T: Decodable>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: HTTPMethod, type: T.Type) async throws -> [T] {
        
        guard var urlComponent = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        
        if !queryParams.isEmpty {
            var urlQuery = [URLQueryItem]()
            for (key,value) in queryParams {
                let query = URLQueryItem(name: key, value: value)
                urlQuery.append(query)
            }
            
            urlComponent.queryItems = urlQuery
        }
        
        guard let URL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue
        
        if bodyParams.count > 0 {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParams)
            request.httpBody = jsonData
        }
        
        for (key,value) in API.combineHeader {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        sleep(UInt32(2.0))
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            let jsonData = try JSONDecoder().decode([T].self, from: data)
            return jsonData
            
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func traditionalApiCall<T: Decodable>(url: String, queryparams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type, completion: @escaping(Result<[T], NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if !queryparams.isEmpty {
            var queryItems = [URLQueryItem]()
            for (key,value) in queryparams {
                let query = URLQueryItem(name: key, value: value)
                queryItems.append(query)
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let URL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue
        
        if bodyParams.count > 0 {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyParams)
                request.httpBody = jsonData
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.requestFailed))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                if let responseData = data {
                    let jsonData = try JSONDecoder().decode([T].self, from: responseData)
                    completion(.success(jsonData))
                }
                
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
    
    func dummyApiCall<T: Decodable>(url: String, queryParams: [String: String], bodyParams: [String: Any], method: HTTPMethod, type: T.Type) -> Future<[T], NetworkError> {
        return Future<[T], NetworkError> { [weak self] promise in
            guard self != nil else {
                return
            }
            do {
                let users = DummyData().users
                let encodedData = try JSONEncoder().encode(users)
                let decodedData = try JSONDecoder().decode([T].self, from: encodedData)
                promise(.success(decodedData))
            } catch {
                promise(.failure(.invalidData))
            }
        }
    }
}

struct API {
    static let baseURL = "https://jsonplaceholder.typicode.com/users/"
    static var combineHeader: [String: String] {
        return ["Content-Type": "application/json"]
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

class DummyData {
    let users: [User] = [User(id: 1, name: "Ankita", email: "ankita@gmail.com"),
                         User(id: 2, name: "Zow", email: "zow@gmail.com"),
                         User(id: 3, name: "Priya", email: "priya@gmail.com"),
                         User(id: 4, name: "Zubair", email: "zubair@gmail.com")]
}

class Cancellable {
    static let shared = Cancellable()
    var set = Set<AnyCancellable>()
    private init() {}
}
