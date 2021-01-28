//
//  ProductJSONDecoder.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct OpenMarketJSONDecoder<T: Decodable> {
    
    static func decodeData(about type: APIType, specificNumer number: Int, test: Bool = false, completionHandler: @escaping (Result<T, OpenMarketError>) -> ()){
        guard let urlRequest = URLRequestManager.makeURLRequest(for: .get, about: type, specificNumer: number) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        var networkHandler = NetworkHandler()
        if test {
            networkHandler = NetworkHandler(session: MockURLSession())
        }
        
        networkHandler.startLoad(about: type, urlRequest: urlRequest, specificNumer: number) { result in
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
