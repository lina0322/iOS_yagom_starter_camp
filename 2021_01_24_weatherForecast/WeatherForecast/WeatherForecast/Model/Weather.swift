//
//  weather.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct Weather: Decodable {
    private let weather: [WeatherIcon]
    let temperature: Temperature
    
    var icon: WeatherIcon? {
        return weather.first
    }
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "main"
    }
}
