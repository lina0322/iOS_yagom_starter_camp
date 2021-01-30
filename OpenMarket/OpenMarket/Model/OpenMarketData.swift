//
//  OpenMarketData.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

class OpenMarketData {
    static var shared = OpenMarketData()
    var currentPage: UInt = 1
    var productList: [Product] = []
    
    private init() { }
}
