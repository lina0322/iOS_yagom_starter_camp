//
//  Products.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/26.
//

struct ProductList: Decodable {
    let page: Int
    let items: [Product]
}
