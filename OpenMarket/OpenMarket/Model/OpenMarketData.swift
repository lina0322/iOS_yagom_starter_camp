//
//  OpenMarketData.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

class OpenMarketData {
    static let shared = OpenMarketData()
    var productList: ProductList?
    var product: Product?
    
    private init() { }
}
