//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct WeatherIcon: Codable {
    let name: String
    var url: String {
           return "https://openweathermap.org/img/w/\(name).png"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
