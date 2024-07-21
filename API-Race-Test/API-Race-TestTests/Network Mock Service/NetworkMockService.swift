//
//  NetworkMockService.swift
//  API-Race-TestTests
//
//  Created by Ankita Kotadiya on 20/07/24.
//

import Foundation
import Combine
@testable import API_Race_Test

class NetworkMockService: NetworkManagerProtocol {
    
    var error = NetworkError.invalidURL
    var isError: Bool = false
    let users: [User] = [User(id: 1, name: "Ankita", email: "ankita@gmail.com"),
                         User(id: 2, name: "Zow", email: "zow@gmail.com"),
                         User(id: 3, name: "Priya", email: "priya@gmail.com"),
                         User(id: 4, name: "Zubair", email: "zubair@gmail.com")]
    
    func callCombineAnyPublisher<T>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: API_Race_Test.HTTPMethod, type: T.Type) -> AnyPublisher<[T], API_Race_Test.NetworkError> where T : Decodable {
        
        return Future<[T], NetworkError> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            if self.isError {
                promise(.failure(self.error))
            }
            
            do {
                let jsonData = try JSONEncoder().encode(self.users)
                let responseData = try JSONDecoder().decode([T].self, from: jsonData)
                promise(.success(responseData))
                
            } catch {
                promise(.failure(.invalidData))
            }
            
        }.eraseToAnyPublisher()
    }
    
    func callCombineAPI<T: Decodable>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: API_Race_Test.HTTPMethod, type: T.Type) -> Future<[T], NetworkError> {
        
        return Future<[T], NetworkError> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            if self.isError {
                promise(.failure(self.error))
            }
            
            do {
                let jsonData = try JSONEncoder().encode(self.users)
                let responseData = try JSONDecoder().decode([T].self, from: jsonData)
                promise(.success(responseData))
                
            } catch {
                promise(.failure(.invalidData))
            }
            
        }
    }

    
    func callAsyncAPI<T>(url: String, queryParams: [String : String], bodyParams: [String : Any], method: API_Race_Test.HTTPMethod, type: T.Type) async throws -> [T] where T : Decodable {
        
        if isError {
            throw error
        }
        
        do {
            let encodedData = try JSONEncoder().encode(users)
            let responseData = try JSONDecoder().decode([T].self, from: encodedData)
            return responseData
            
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func traditionalApiCall<T: Decodable>(url: String, queryparams: [String : String], bodyParams: [String : Any], method: API_Race_Test.HTTPMethod, type: T.Type, completion: @escaping (Result<[T], API_Race_Test.NetworkError>) -> Void) {
        
        if isError {
            completion(.failure(error))
        }
        do {
            let encodedData = try JSONEncoder().encode(users)
            let decodedData = try JSONDecoder().decode([T].self, from: encodedData)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.invalidResponse))
        }
    }
}
