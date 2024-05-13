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
    
}

class NetworkManager: NetworkManagerProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    
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
