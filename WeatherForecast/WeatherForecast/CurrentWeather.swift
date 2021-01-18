//
//  weather.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import Foundation

struct WeatherIcon: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}

struct Temperature: Codable {
    let average: Double
    let min: Double
    let max: Double
    
    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case min = "temp_min"
        case max = "temp_max"
    }
}

struct CurrentWeather: Codable {
    let icon: WeatherIcon
    let temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
    }
}

struct Forecast: Codable {
    let icon: [WeatherIcon]
    let temperature: Temperature
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
        case time = "dt_txt"
    }
}

struct ForecastList: Codable {
    let list: [Forecast]
}
