//
//  ProductAPIManager.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/25.
//

import Foundation

struct OpenMarketAPIManager {
    enum APIType: CustomStringConvertible {
        case page
        case product
        
        var description: String {
            switch self {
            case .page:
                return "items/"
            case .product:
                return "item/"
            }
        }
    }

    private static let baseURL = "https://camp-open-market.herokuapp.com/"
        
    static func startLoad(about type: APIType, specificNumer number: Int, completionHandler: @escaping (Result<Data, StringFormattingError>) -> ()) {
        guard var urlRequest = makeURLRequest(about: type, specificNumer: number) else {
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
    
    private static func makeURLRequest(about type: APIType, specificNumer number: Int) -> URLRequest? {
        let absoluteURL = "\(baseURL)\(type)\(number)/"
        guard let url = URL(string: absoluteURL) else {
            debugPrint(StringFormattingError.wrongURL)
            return nil
        }
        return URLRequest(url: url)
    }
}
