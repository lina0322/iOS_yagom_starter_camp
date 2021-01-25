import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    private let timeStampDate: Double
    
    var registrationDate: Date {
        return Date(timeIntervalSince1970: timeStampDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case timeStampDate = "registration_date"
    }
}
