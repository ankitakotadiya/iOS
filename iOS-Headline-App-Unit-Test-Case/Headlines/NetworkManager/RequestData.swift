import Foundation

enum Method: String {
    case get = "GET"
}

struct RequestData<Value> {
    
    var method: Method
    var path: String
    var params: [String: String]
    
    init(method: Method = .get, path: String, params: [String: String] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }
}
