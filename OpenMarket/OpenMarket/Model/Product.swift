//
//  Product.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct Product: Codable {
    let id: Int?
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let thumbnailURLs: [String]?
    let imageURLs: [String]?
    let timeStampDate: Double?
    let password: String?
    
    init(forPostPassword password: String, title: String, descriptions: String, price: Int, currency: String, stock: Int, discountedPrice: Int? = nil, images: [String]) {
        self.password = password
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.imageURLs = images
        
        self.id = nil
        self.thumbnailURLs = nil
        self.timeStampDate = nil
    }
    
    init(forPatchPassword password: String, title: String? = nil, descriptions: String? = nil, price: Int? = nil, currency: String? = nil, stock: Int? = nil, discountedPrice: Int? = nil, images: [String]? = nil) {
        self.password = password
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.imageURLs = images

        self.id = nil
        self.thumbnailURLs = nil
        self.timeStampDate = nil
    }
    
    init(forDeletePassword password: String, id: Int) {
        self.password = password
        self.id = id
        
        self.title = nil
        self.descriptions = nil
        self.price = nil
        self.currency = nil
        self.stock = nil
        self.discountedPrice = nil
        self.thumbnailURLs = nil
        self.imageURLs = nil
        self.timeStampDate = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, password
        case thumbnailURLs = "thumbnails"
        case imageURLs = "images"
        case discountedPrice = "discounted_price"
        case timeStampDate = "registration_date"
    }
    
    func makeRegistrationDate() -> Date? {
        guard let timeStampDate = timeStampDate else {
            return nil
        }
        return Date(timeIntervalSince1970: timeStampDate)
    }
}
