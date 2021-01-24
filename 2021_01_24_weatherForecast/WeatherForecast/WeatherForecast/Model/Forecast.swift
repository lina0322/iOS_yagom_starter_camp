//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct Forecast: Decodable {
    private let weather: [WeatherIcon]
    let temperature: Temperature
    let time: String

    var icon: WeatherIcon? {
        return weather.first
    }
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "main"
        case time = "dt_txt"
    }
}
