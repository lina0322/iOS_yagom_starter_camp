//
//  Url.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

enum Api {
    enum Kind: String {
        case currentWeather = "weather"
        case forecast = "forecast"
    }
    
    static let myKey = "4119f1d1ea30af76104279475caf11c7"
    static let url = "https://api.openweathermap.org/data/2.5/%@?lat=%f&lon=%f&appid=%@"
    static let namsanLatitude = 37.55406295911284
    static let namsanLongitude = 126.98079780043565
}
