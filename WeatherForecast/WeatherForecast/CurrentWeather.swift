//
//  weather.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct CurrentWeather: Codable {
    let icon: [WeatherIcon]
    let temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
    }
}
