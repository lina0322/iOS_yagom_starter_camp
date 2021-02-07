//
//  URLRequestManager.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

import Foundation

struct URLRequestManager {
    static let baseURL = "https://camp-open-market.herokuapp.com"

    static let boundary = UUID().uuidString
    
    static func makeURLRequest(for httpMethod: HTTPMethod, about apiRequestType: APIRequestType = .loadPage(page: 1)) -> URLRequest? {
        let absoluteURL: String = "\(baseURL)\(apiRequestType.urlPath)"
        guard let url = URL(string: absoluteURL) else {
            debugPrint(OpenMarketError.wrongURL)
            return nil
        }
        var urlRequest = URLRequest(url: url)
        let contentType = httpMethod.makeContentType(boundary: boundary)
        
        urlRequest.httpMethod = "\(httpMethod)"
        urlRequest.setValue(contentType, forHTTPHeaderField: HTTPMethod.contextTypeText)
        return urlRequest
    }
}
