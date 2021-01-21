//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import Foundation

struct Temperature: Decodable {
    private let kelvinAverage: Double
    private let kelvinMinimum: Double
    private let kelvinMaximum: Double
    
    var celsiusAverage: String {
        return changeToCelsiusText(kelvinAverage)
    }
    var celsiusMinimum: String {
        return changeToCelsiusText(kelvinMinimum)
    }
    var celsiusMaximum: String {
        return changeToCelsiusText(kelvinMaximum)
    }

    enum CodingKeys: String, CodingKey {
        case kelvinAverage = "temp"
        case kelvinMinimum = "temp_min"
        case kelvinMaximum = "temp_max"
    }
    
    private func changeToCelsiusText(_ temperature: Double) -> String {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: temperature)
        let celsiusText = String(format: InitialValue.celsiusFormat, celsius)
        
        return celsiusText
    }
}
