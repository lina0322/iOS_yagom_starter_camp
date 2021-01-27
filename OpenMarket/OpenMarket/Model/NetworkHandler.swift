//
//  ProductAPIManager.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct NetworkHandler {
    static func startLoad(about type: APIType = .product, urlRequest: URLRequest, specificNumer number: Int? = nil, completionHandler: @escaping (Result<Data, StringFormattingError>) -> ()) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completionHandler(.failure(.severConnectionFailure))
                return
            }
            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                debugPrint(response.debugDescription)
                completionHandler(.failure(.severConnectionFailure))
                return
            }
            if let data = data {
                completionHandler(.success(data))
                return
            }
            completionHandler(.failure(.wrongData))
        }.resume()
    }
}
