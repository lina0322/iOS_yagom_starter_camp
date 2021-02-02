//
//  OpenMarketData.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

class OpenMarketData {
    static let shared = OpenMarketData()
    var tableViewProductList: [Product] = []
    var tableViewCurrentPage: UInt = 1
    var collectionViewProductList: [Product] = []
    var collectionViewCurrentPage: UInt = 1

    private init() { }
}
