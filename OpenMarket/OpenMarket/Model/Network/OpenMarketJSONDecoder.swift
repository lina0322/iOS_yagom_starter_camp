//
//  ProductJSONDecoder.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct OpenMarketJSONDecoder<T: Decodable> {
    
    static func decodeData(about apiRequestType: APIRequestType, networkHandler: NetworkHandler = NetworkHandler(), completionHandler: @escaping (Result<T, OpenMarketError>) -> ()) {
        guard let urlRequest = URLRequestManager.makeURLRequest(for: .get, about: apiRequestType) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        networkHandler.startLoad(about: apiRequestType, urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    completionHandler(.failure(.decodingFailure))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
