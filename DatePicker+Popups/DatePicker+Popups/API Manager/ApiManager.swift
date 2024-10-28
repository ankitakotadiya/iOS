//
//  ApiManager.swift
//  DatePicker+Popups
//
//  Created by Ankita Kotadiya on 27/10/24.
//

import Foundation
import UIKit


enum APIError: Error {
    case invalidURL
    case networkError
}

enum Method: String {
    case get = "GET"
}

protocol APIManaging: AnyObject {
    var session: URLSession {get set}
}

class ApiManager: APIManaging {
    static let shared = ApiManager()
    
    var session: URLSession
    let host = ""
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute<T: Decodable>(_ request: Request<T>) async -> Result<T, APIError> {
        var urlRequest: URLRequest
        
        do {
            urlRequest = try _urlRequest(_request: request)
        } catch {
            return .failure(APIError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            let userData = try JSONDecoder().decode(T.self, from: data)
            return .success(userData)
            
        } catch {
            return .failure(APIError.networkError)
        }
    }
    
    private func _urlRequest<T>(_request: Request<T>) throws -> URLRequest {
        guard let url = URL(host: host, request: _request) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = _request.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
}

extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        var existingComponents = components?.queryItems ?? []
        existingComponents.append(contentsOf: queryItems)
        
        if existingComponents.count > 0{
            components?.queryItems = existingComponents
        }
        return components?.url
    }
    
    init?<T>(host: String, request: Request<T>) {
        var queryItems = request.params.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let baseURL = URL(string: host) else {
            return nil
        }
        
        let urlPath = baseURL.appending(path: request.path, directoryHint: .isDirectory).url(with: queryItems)
        
        guard let urlString = urlPath?.absoluteString else {
            return nil
        }
        
        self.init(string: urlString)
    }
}

struct Request<T> {
    let method: Method
    var path: String
    var params: [String: String]
    
    init(method: Method = .get, path: String, params: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }
}
