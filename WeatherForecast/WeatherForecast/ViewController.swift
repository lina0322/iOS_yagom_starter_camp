//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var currentWeater: Weather?
    private var forecast: ForecastList?
    private let celsiusFormat = "%.1f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lat: Double = 37
        let lon: Double = 126
        
        decodeCurrentWeaterFromAPI(lat, lon)
        decodeForecastFromAPI(lat, lon)
    }
    
    private func changeToCelsiusText(_ temperature: Double) -> String {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: 268.15)
        let celsiusText = String(format: celsiusFormat, celsius)
        
        return celsiusText
    }
    
    private func decodeCurrentWeaterFromAPI(_ lat: Double, _ lon: Double) {
        let session = URLSession(configuration: .default)
        let currentWeatherURL = String(format: Api.url, Api.Kind.currentWeather.rawValue, lat, lon, Api.myKey)
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
    
    private func decodeForecastFromAPI(_ lat: Double, _ lon: Double) {
        let session = URLSession(configuration: .default)
        let forecastURL = String(format: Api.url, Api.Kind.forecast.rawValue, lat, lon, Api.myKey)
        guard let url:URL = URL(string: forecastURL) else {
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
                self.forecast = try JSONDecoder().decode(ForecastList.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
