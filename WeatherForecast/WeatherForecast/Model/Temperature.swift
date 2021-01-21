//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import Foundation

struct Temperature: Decodable {
    let average: Double
    let minimum: Double
    let maximum: Double

    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case minimum = "temp_min"
        case maximum = "temp_max"
    }
}
