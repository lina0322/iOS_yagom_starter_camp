//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

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
