//
//  URLRequestManager.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

import Foundation

struct URLRequestManager {
    private static let baseURL = "https://camp-open-market.herokuapp.com/"

    static func makeURLRequest(for httpMethod: HTTPMethod, about type: APIType = .product, specificNumer number: Int?) -> URLRequest? {
        var absoluteURL: String
        if let number = number {
            absoluteURL = "\(baseURL)\(type)\(number)/"
        } else {
            absoluteURL = "\(baseURL)\(type)/"
        }
        
        guard let url = URL(string: absoluteURL) else {
            debugPrint(StringFormattingError.wrongURL)
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(httpMethod)"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
