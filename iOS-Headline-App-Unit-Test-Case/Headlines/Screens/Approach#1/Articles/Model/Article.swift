import Foundation
import RealmSwift

class Article: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var headline = ""
    @Persisted var body = ""
    @Persisted var published: Date?
    @Persisted var rawImageURL: String?
    @Persisted var isFavourite: Bool = false
    
    var imageURL: URL? {
        guard let rawImageURL = rawImageURL else { return nil }
        return URL(string: rawImageURL)
    }
    
    static let formatter = ISO8601DateFormatter()
    
    
//    static var all: [Article] {
//        let realm = try! Realm()
//        let all = realm.objects(Article.self)
//        return Array(all)
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case headline = "webTitle"
        case body = "fields"
        case published = "webPublicationDate"
        case rawImageURL = "main"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headline = try container.decode(String.self, forKey: .headline)
        
        id = try container.decode(String.self, forKey: .id)
        
        if let publicationDate = try? container.decode(String.self, forKey: .published) {
            published = publicationDate.toDate()
        }
        
        if let fields = try? container.decode([String: String].self, forKey: .body) {
            body = fields["body"]?.strippingTags ?? ""
            rawImageURL = fields["main"]?.url?.absoluteString
        }
    }
}

// MARK: - API Request Data
extension Article {
    static func getHeadlines(for queryParams: [String: String]) -> RequestData<Page<Article>> {
        return RequestData(method: .get, path: "/search?", params: queryParams)
    }
}

fileprivate extension String {
    var strippingTags: String {
        var result = self.replacingOccurrences(of: "</p> <p>", with: "\n\n") as NSString
        
        var range = result.range(of: "<[^>]+>", options: .regularExpression)
        while range.location != NSNotFound {
            result = result.replacingCharacters(in: range, with: "") as NSString
            range = result.range(of: "<[^>]+>", options: .regularExpression)
        }
        
        return result as String
    }
    
    var url: URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: (self as NSString).length))
        return matches.first?.url
    }
}
