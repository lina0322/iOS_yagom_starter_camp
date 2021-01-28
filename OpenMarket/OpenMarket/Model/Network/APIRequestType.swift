//
//  APIType.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

enum APIRequestType {
    case loadPage(page: UInt)
    case loadProduct(id: UInt)
    case postProduct
    case patchProduct(id: UInt)
    case deleteProduct(id: UInt)
    
    var urlPath: String {
        switch self {
        case .loadPage(let page):
            return "/items/\(page)"
        case .loadProduct(let id):
            return "/item/\(id)"
        case .postProduct:
            return "/item/"
        case .patchProduct(let id):
            return "/item/\(id)"
        case .deleteProduct(let id):
            return "/item/\(id)"
        }
    }
}
