//
//  ProductAPIManager.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

struct NetworkHandler {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func startLoad(urlRequest: URLRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
        session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completionHandler(.failure(.severConnectionFailure))
                return
            }
            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
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
