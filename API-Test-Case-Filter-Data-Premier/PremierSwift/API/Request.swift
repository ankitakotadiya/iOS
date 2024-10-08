import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<Value> {
    
    var method: Method
    var path: String
    var queryParams: [String: String]
    
    init(method: Method = .get, path: String, _queryParams: [String: String] = [:]) {
        self.method = method
        self.path = path
        self.queryParams = _queryParams
    }
    
}
