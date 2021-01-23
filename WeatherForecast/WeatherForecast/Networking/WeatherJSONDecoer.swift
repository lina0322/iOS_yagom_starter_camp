//
//  WeatherJSONDecoer.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/23.
//

import Foundation

struct APIJSONDecoder <T: Decodable> {
    func decodeAPIData(url: URLRequest, result: @escaping (Result<T, StringFormattingError>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                result(.failure(.failedRequest))
                return
            }
            
            do {
                let decodeResult: T = try JSONDecoder().decode(T.self, from: data)
                result(.success(decodeResult))
            } catch {
                result(.failure(.decodingFailure))
            }
        }.resume()
    }
}
