import Foundation

enum APIError: Error {
    case networkError
    case parsingError
    case invalidURL
}


extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var existingComponents: [URLQueryItem] = components?.queryItems ?? []
        existingComponents.append(contentsOf: queryItems)
        components?.queryItems = existingComponents
        
        // Based on the feedback, we will not modify the initializer at this time.
        // Otherwise, allowing an optional URL could facilitate handling the nil case more gracefully.
        return components?.url
    }
    
    // Some of the feedback I have already provided in PR so I am changing here to avoid conflicts.
    init?<Value>(_ host: String, _ apiKey: String, _ request: Request<Value>) {
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        queryItems += request.queryParams.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let baseURL = URL(string: host) else {
            return nil
        }
        
        let urlPath = baseURL.appendingPathComponent(request.path).url(with: queryItems)
        
        guard let urlString = urlPath?.absoluteString else {
            return nil
        }
        
        self.init(string: urlString)
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
        let urlrequest: URLRequest
        
        do {
            urlrequest = try urlRequest(for: request)
        } catch {
            completion(.failure(.invalidURL))
            return
        }
        urlSession.dataTask(with: urlrequest) { responseData, response, _ in
            if let data = responseData {
                let response: Value
                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: data)
//                    print(jsonObject)
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
    
    private func urlRequest<Value>(for request: Request<Value>) throws -> URLRequest {
        guard let url = URL(host, apiKey, request) else {
            throw APIError.invalidURL
        }
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return result
    }
    
}
