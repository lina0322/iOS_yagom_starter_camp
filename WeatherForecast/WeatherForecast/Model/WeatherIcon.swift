//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

struct WeatherIcon: Decodable {
    private let name: String
    
    var url: String {
        return String(format: WeatherAPIManager.imageURL, name)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
