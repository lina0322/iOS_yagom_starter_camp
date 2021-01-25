import Foundation

struct ProductList: Decodable {
    let page: Int
    let items: [Product]
}
