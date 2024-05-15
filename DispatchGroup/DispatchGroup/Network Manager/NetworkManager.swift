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
    func fetchDataWithoutCombine<T: Decodable>(url: Path, params: [String: Any], type: T.Type, completion: @escaping ([T]) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchDataWithoutCombine<T: Decodable>(url: Path, params: [String: Any], type: T.Type, completion: @escaping ([T]) -> Void) {
        guard var URLcomponents = URLComponents(string: url.rawValue) else {
            completion([])
            return
        }
        
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        for (key,value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        
        URLcomponents.queryItems = queryItems
        
        guard let urlRequest = URLcomponents.url else {
            completion([])
            return
        }
        var request = URLRequest(url: urlRequest)
        request.setValue("Content-Type", forHTTPHeaderField: "application/json")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let er = error {
                print(er.localizedDescription)
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }
            
            if let responseData = data {
                do {
                    let decoder = JSONDecoder()
                    let posts = try decoder.decode([T].self, from: responseData)
                    completion(posts)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion([])
                }
            }
            
        }
        task.resume()
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
