//
//  Uploader.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

import Foundation

struct Uploader {
    
    static func uploadData(by httpMethod: HTTPMethod, product: Product, apiRequestType: APIRequestType, completionHandler: @escaping (Result<Any, OpenMarketError>) -> ()) {
        guard var urlRequest = URLRequestManager.makeURLRequest(for: httpMethod, about: apiRequestType) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        encode(data: product) { result in
            switch result {
            case .success(let data):
                urlRequest.httpBody = data
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        NetworkHandler().startLoad(about: apiRequestType, urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private static func encode(data: Product,  completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            completionHandler(.success(encodedData))
        } catch {
            completionHandler(.failure(.encodingFailure))
        }
    }
}
