//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct WeatherIcon: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
