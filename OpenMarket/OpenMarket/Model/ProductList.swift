//
//  Products.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/26.
//

import Foundation

struct ProductList: Decodable {
    let page: Int
    let items: [Product]
}
