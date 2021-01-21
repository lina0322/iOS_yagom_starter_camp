//
//  Url.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

enum WeatherApiManager {
    enum Kind: String {
        case currentWeather = "weather"
        case forecast = "forecast"
    }
    
    static let myKey = "4119f1d1ea30af76104279475caf11c7"
    static let dataURL = "https://api.openweathermap.org/data/2.5/%@?lat=%f&lon=%f&appid=%@"
    static let imageURL = "https://openweathermap.org/img/w/%@.png"
}
