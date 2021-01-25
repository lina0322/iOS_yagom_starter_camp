//
//  Products.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/26.
//

import Foundation

struct Products: Decodable {
    let page: Int
    let list: [Product]
    
    enum CodingKeys: String, CodingKey {
        case page
        case list = "items"
    }
}
