//
//  APIType.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

enum APIType: CustomStringConvertible {
    case page
    case product
    
    var description: String {
        switch self {
        case .page:
            return "items/"
        case .product:
            return "item/"
        }
    }
}
