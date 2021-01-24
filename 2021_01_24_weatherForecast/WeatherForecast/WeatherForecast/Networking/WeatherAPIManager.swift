//
//  Url.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import Foundation
import CoreLocation

struct WeatherAPIManager {
    enum APIType: CustomStringConvertible {
        case currentWeather
        case forecast
        
        var description: String {
            switch self {
            case .currentWeather:
                return "weather?"
            case .forecast:
                return "forecast?"
            }
        }
    }
    
    static let imageURL = "https://openweathermap.org/img/w/%@.png"
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    static func makeURLRequest(apiType: APIType, location: CLLocation) -> URLRequest? {
        guard var absoluteURL = URLComponents(string: "\(baseURL)\(apiType)") else {
            return nil
        }
        
        absoluteURL.queryItems = makeQueryItems(location: location)
        guard let url = absoluteURL.url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    private static func makeQueryItems(location: CLLocation) -> [URLQueryItem] {
        let myKey = "4119f1d1ea30af76104279475caf11c7"
        let units = "metric" // 섭씨
        
        let queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "appid", value: myKey),
            URLQueryItem(name: "units", value: units)
        ]
        return queryItems
    }
}
