import Foundation

enum APIError: Error {
    case networkError
    case parsingError
}


extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var existingComponents: [URLQueryItem] = components?.queryItems ?? []
        existingComponents.append(contentsOf: queryItems)
        components?.queryItems = existingComponents
        
        // Based on the feedback, we will not modify the initializer at this time.
        // Otherwise, allowing an optional URL could facilitate handling the nil case more gracefully.
        return components?.url ?? self
    }
    
    // Some of the feedback I have already provided in PR so I am changing here to avoid conflicts.
    init<Value>(_ host: String, _ apiKey: String, _ request: Request<Value>) {
        let queryItems = [ ("api_key", apiKey) ]
            .map { name, value in URLQueryItem(name: name, value: "\(value)") }
        
        let url = URL(string: host)!
            .appendingPathComponent(request.path)
            .url(with: queryItems)
        
        self.init(string: url.absoluteString)!
    }
}

protocol APIManaging {
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void)
}

final class APIManager: APIManaging {
    
    static let shared = APIManager()
    
    let host = API.baseURL
    let apiKey = API.apiKey
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        urlSession.dataTask(with: urlRequest(for: request)) { responseData, response, _ in
            if let data = responseData {
                let response: Value
                do {
                    response = try JSONDecoder().decode(Value.self, from: data)
                } catch {
                    completion(.failure(.parsingError))
                    return
                }
                
                completion(.success(response))
            } else {
                completion(.failure(.networkError))
            }
        }.resume()
    }
    
    private func urlRequest<Value>(for request: Request<Value>) -> URLRequest {
        let url = URL(host, apiKey, request)
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return result
    }
    
}
