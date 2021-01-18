//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

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
