//
//  APIManager.swift
//  SignupLogin
//
//  Created by Ankita Kotadiya on 28/07/23.
//

import Foundation
import Combine
import UIKit

enum Endpoint: String {
    case users
}

enum HttpMethod: String {
    case GET
    case POST
}

class ApiManager {
    
    static let shared = ApiManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    func getData<T: Decodable>(endPoint: Endpoint, method: HttpMethod, headers: [String:Any], parameters: [String:Any]) -> Future<[T], Error> {
        
        return Future<[T], Error> { [weak self] promise in
            
            guard let url = URL(string: APIs.baseURL.appending(endPoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            print("My Url is", url)
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            for (key,value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            
            request.httpBody = jsonData
            
            self?.session.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { (completion) in
                    
                    if case let .failure(error) = completion {
                        switch error {
                            
                        case let decidingerror as DecodingError:
                            return promise(.failure(decidingerror))
                            
                        default:
                            return promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { (dataresponse) in
                    promise(.success(dataresponse))
                }
                .store(in: &self!.cancellables)
        }
    }
    
    func uploadData<T: Decodable>(endPoint: Endpoint, method: HttpMethod, headers: [String:Any], parameters: [String:Any], imageParameters: [String:Any]) -> Future<[T], Error> {
        
        return Future<[T], Error> { [weak self] promise in
            
            guard let url = URL(string: APIs.baseURL.appending(endPoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            print("My Url is", url)
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            for (key,value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
            
            let boundary = self?.getBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary ?? "")", forHTTPHeaderField: "Content-Type")
            //            request.addValue("multipart/form-data", forHTTPHeaderField: "Accept")
            
            if let bodyData = self?.createBodyParameters(parameters: parameters, imageParameterrs: imageParameters) {
                request.httpBody = bodyData
            }
            
            self?.session.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { (completion) in
                    
                    if case let .failure(error) = completion {
                        switch error {
                            
                        case let decidingerror as DecodingError:
                            return promise(.failure(decidingerror))
                            
                        default:
                            return promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { (dataresponse) in
                    promise(.success(dataresponse))
                }
                .store(in: &self!.cancellables)
        }
    }
    
    func createBodyParameters(parameters: [String:Any], imageParameterrs: [String:Any]) -> Data {
        
        var bodyData = Data()
        let bounday = getBoundaryString()
        
        if !parameters.isEmpty {
            
            for (key,value) in parameters {
                bodyData.append("--\(bounday)\r\n".toData())
                bodyData.append("Content-Disposition: form-data; name=\(key)\r\n\r\n".toData())
                bodyData.append("Content-Disposition: form-data; name=\(value)\r\n".toData())
                
            }
        }
        
        let mimeType = "image/jpg"
        
        if !imageParameterrs.isEmpty {
            
            for (key,value) in imageParameterrs {
                
                let imageName = "\(key).jpg"
                bodyData.append("--\(bounday)\r\n".toData())
                bodyData.append("Content-Disposition: form-data; name=\(key); filename=\(imageName)\r\n".toData())
                bodyData.append("Content-Type: \(mimeType)\r\n\r\n".toData())
                
                if let image = value as? UIImage {
                    if let imgData = image.jpegData(compressionQuality: 1.0) {
                        bodyData.append(imgData)
                    }
                }
                
                bodyData.append("\r\n".toData())
                bodyData.append("--\(bounday)--\r\n".toData())
                
            }
        }
        
        return bodyData
        
    }
    
    func getBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError {
    
    var errorDescription: String? {
        switch self {
        
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
