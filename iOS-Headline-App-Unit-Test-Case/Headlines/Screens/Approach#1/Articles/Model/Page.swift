import Foundation

struct Page<T: Decodable>: Decodable {
    // By adding more properties related to the Pagination can be handled efficiently.
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case response, results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.results = try responseContainer.decode([T].self, forKey: .results)
    }
}
