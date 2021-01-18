//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var currentWeater: Weather?
    private let myKey = "4119f1d1ea30af76104279475caf11c7"
    private let lat = 37
    private let lon = 126
    private let celsiusFormat = "%.1f"
    private var currentWeatherURL: String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(myKey)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeCurrentWeaterFromAPI()
    }
    
    private func changeToCelsiusText(_ temperature: Double) -> String {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: 268.15)
        let celsiusText = String(format: celsiusFormat, celsius)
        
        return celsiusText
    }
    
    private func decodeCurrentWeaterFromAPI() {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: currentWeatherURL) else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data? , response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                self.currentWeater = try JSONDecoder().decode(Weather.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
