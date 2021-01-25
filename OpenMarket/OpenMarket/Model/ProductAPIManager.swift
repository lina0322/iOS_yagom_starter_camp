//
//  ProductAPIManager.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

class ProductAPIManager {
    static let shared = ProductAPIManager()
    private let baseURL = "https://camp-open-market.herokuapp.com/"
    private var currentPage = 1
    
    private init() {}
    
    func startLoad(completionHandler: @escaping (Result<Data, StringFormattingError>) -> ()) {
        guard var urlRequest = makeURLRequest() else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        urlRequest.httpMethod = "GET"
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
    
    private func makeURLRequest() -> URLRequest? {
        let absoluteURL = "\(baseURL)/items/\(currentPage)/"
        guard let url = URL(string: absoluteURL) else {
            debugPrint(StringFormattingError.wrongURL)
            return nil
        }
        currentPage += 1
        return URLRequest(url: url)
    }
}
