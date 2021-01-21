//
//  Url.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct WeatherApiManager {
    enum Kind: String {
        case currentWeather = "weather"
        case forecast = "forecast"
    }
    
    static let imageURL = "https://openweathermap.org/img/w/%@.png"
    
    static func makeApiURL(latitude: Double, longitude: Double, kind: Kind) -> String {
        let myKey = "4119f1d1ea30af76104279475caf11c7"
        let dataURL = "https://api.openweathermap.org/data/2.5/%@?lat=%f&lon=%f&units=metric&appid=%@"

        return String(format: dataURL, kind.rawValue, latitude, longitude, myKey)
    }
}
