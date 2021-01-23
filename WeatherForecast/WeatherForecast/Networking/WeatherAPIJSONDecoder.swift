//
//  WeatherAPIJSONDecoder.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/23.
//

import CoreLocation

struct WeatherAPIJSONDecoder<T: Decodable> {
    func updateData(apiType: WeatherAPIManager.APIType, location: CLLocation, result: @escaping (Result<T, StringFormattingError>) -> ()) {
        guard var urlRequest = WeatherAPIManager.makeURLRequest(apiType: apiType, location: location) else {
            result(.failure(.failedRequest))
            return
        }
        
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
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
