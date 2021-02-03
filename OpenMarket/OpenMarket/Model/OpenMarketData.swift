//
//  OpenMarketData.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

class OpenMarketData {
    static let shared = OpenMarketData()
    var productList: [Product] = []
    var currentPage: Int = 1
    var isPaging = false
    var hasPage = true

    private init() { }
}
