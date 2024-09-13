import UIKit
import RealmSwift
import Alamofire


protocol NetworkManagerProvider: AnyObject {
    func execute<T: Decodable>(request: RequestData<T>, completion: @escaping ((T?, Error?) -> Void))
}

final class NetworkManager: NetworkManagerProvider {
    
//    static let shared = NetworkManager()
    
    let host = API.baseURL
    let apiKey = API.apiKey
    
    func execute<T: Decodable>(request: RequestData<T>, completion: @escaping ((T?, Error?) -> Void))  {
        let fullUrl = host + request.path
        AF.request(fullUrl, parameters: request.params, encoding: URLEncoding.default).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let value):
                completion(value, nil)
                
            case .failure(_):
                completion(nil, response.error)
            }
        }
    }
}
