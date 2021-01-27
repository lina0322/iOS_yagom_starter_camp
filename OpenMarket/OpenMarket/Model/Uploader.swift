//
//  Uploader.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

import Foundation

struct Uploader {
    static func uploadData(by httpMethod: HTTPMethod, product: Product, specificNumer number: Int? = nil, completionHandler: @escaping (Result<Any, StringFormattingError>) -> ()){
        guard var urlRequest = URLRequestManager.makeURLRequest(for: httpMethod, specificNumer: number) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        encoder(data: product) { result in
            switch result {
            case .success(let data):
                urlRequest.httpBody = data
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        OpenMarketAPIManager.startLoad(urlRequest: urlRequest, specificNumer: number) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private static func encoder(data: Product,  completionHandler: @escaping (Result<Data, StringFormattingError>) -> ()){
        let encoder = JSONEncoder()
        
        do {
            let encodedData = try encoder.encode(data)
            completionHandler(.success(encodedData))
        } catch {
            completionHandler(.failure(.encodingFailure))
        }
    }
}
