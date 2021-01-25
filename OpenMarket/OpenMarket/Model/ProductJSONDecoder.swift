//
//  ProductJSONDecoder.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct ProductJSONDecoder {
    static let decoder = JSONDecoder()

    static func decodeData(completionHandler: @escaping (Result<Products, StringFormattingError>) -> ()) {
        ProductAPIManager.shared.startLoad { result in
            switch result {
            case .success(let data):
                do {
                    let productList = try decoder.decode(Products.self, from: data)
                    completionHandler(.success(productList))
                } catch {
                    completionHandler(.failure(.decodingFailure))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
