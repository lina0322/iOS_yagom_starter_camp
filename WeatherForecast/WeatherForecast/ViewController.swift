//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let celsiusFormat = "%.1f"
    
    func changeToCelsiusText(_ temperature: Double) -> String {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: 268.15)
        let celsiusText = String(format: celsiusFormat, celsius)
        
        return celsiusText
    }
}
