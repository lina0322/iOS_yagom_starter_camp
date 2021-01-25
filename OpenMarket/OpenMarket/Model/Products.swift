import Foundation

struct Products: Decodable {
    let page: Int
    let lists: [Product]
    
    enum CodingKeys: String, CodingKey {
        case page
        case lists = "items"
    }
}
