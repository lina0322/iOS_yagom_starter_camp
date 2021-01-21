//
//  Url.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import Foundation

class WeatherAPIManager {
    enum Kind {
        case currentWeather
        case forecast
        
        var dataURL: String {
            let url = "https://api.openweathermap.org/data/2.5"
            switch self {
            case .currentWeather:
                return "\(url)/weather?"
            case .forecast:
                return "\(url)/forecast?"
            }
        }
    }
    
    static let shared = WeatherAPIManager()
    static let imageURL = "https://openweathermap.org/img/w/%@.png"

    private init () {}
    
    func makeURLRequest(kind: Kind, latitude: Double, logitude: Double) -> URLRequest? {
        guard var urlComponents = URLComponents(string: kind.dataURL) else {
            return nil
        }
        urlComponents.queryItems = makeQueryItems(latitude: latitude, logitude: logitude)
        guard let url = urlComponents.url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    private func makeQueryItems(latitude: Double, logitude: Double) -> [URLQueryItem] {
        let myKey = "4119f1d1ea30af76104279475caf11c7"
        let units = "metric" // 섭씨
        
        let queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(logitude)),
            URLQueryItem(name: "appid", value: myKey),
            URLQueryItem(name: "units", value: units)
        ]
        return queryItems
    }
}
