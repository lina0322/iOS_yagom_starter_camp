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
    let imageFiles: [Data]?
    let imageURLs: [String]?
    let timeStampDate: Double?
    let password: String?
    
    init(forPostPassword password: String, title: String, descriptions: String, price: Int, currency: String, stock: Int, discountedPrice: Int? = nil, imageFiles: [Data]) {
        self.password = password
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.imageFiles = imageFiles
        
        self.id = nil
        self.imageURLs = nil
        self.thumbnailURLs = nil
        self.timeStampDate = nil
    }
    
    init(forPatchPassword password: String, id: Int, title: String? = nil, descriptions: String? = nil, price: Int? = nil, currency: String? = nil, stock: Int? = nil, discountedPrice: Int? = nil, imageFiles: [Data]? = nil) {
        self.password = password
        self.id = id
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.imageFiles = imageFiles
        
        self.imageURLs = nil
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
        self.imageFiles = nil
        self.imageURLs = nil
        self.timeStampDate = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, password, imageFiles
        case thumbnailURLs = "thumbnails"
        case imageURLs = "images"
        case discountedPrice = "discounted_price"
        case timeStampDate = "registration_date"
    }
    
    var parameters: [String : Any?] {[
        "title": title,
        "descriptions": descriptions,
        "price": price,
        "currency": currency,
        "stock": stock,
        "discounted_price": discountedPrice,
        "images": imageFiles,
        "password": password
    ]}
    
    func makeRegistrationDate() -> Date? {
        guard let timeStampDate = timeStampDate else {
            return nil
        }
        return Date(timeIntervalSince1970: timeStampDate)
    }
}
