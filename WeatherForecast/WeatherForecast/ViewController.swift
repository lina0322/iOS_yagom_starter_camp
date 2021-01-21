//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var latitude: Double = InitialValue.namsanLatitude
    private var longitude: Double = InitialValue.namsanLongitude
    private var currentAddress: String = InitialValue.emptyString
    
    private var currentWeather: Weather?
    private var forecast: ForecastList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocationManager()
    }
        
    /// 현재 날씨, 일기 예보 데이터를 저장하고, 위치 정보를 한국어 주소로 변환
    private func setUpData() {
        decodeCurrentWeaterFromAPI()
        decodeForecastFromAPI()
        findCurrentAddress()
    }
    
    // MARK: - decode
    private func decodeCurrentWeaterFromAPI() {
        let session = URLSession(configuration: .default)
        let currentWeatherURL = String(format: WeatherApiManager.dataURL, WeatherApiManager.Kind.currentWeather.rawValue, latitude, longitude, WeatherApiManager.myKey)
        guard let url:URL = URL(string: currentWeatherURL) else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            
            do {
                self.currentWeather = try JSONDecoder().decode(Weather.self, from: data)
            } catch {
                self.showToast(message: StringFormattingError.unknown.description)
            }
        }
        dataTask.resume()
    }
    
    private func decodeForecastFromAPI() {
        let session = URLSession(configuration: .default)
        let forecastURL = String(format: WeatherApiManager.dataURL, WeatherApiManager.Kind.forecast.rawValue, latitude, longitude, WeatherApiManager.myKey)
        guard let url:URL = URL(string: forecastURL) else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            
            do {
                self.forecast = try JSONDecoder().decode(ForecastList.self, from: data)
            } catch {
                self.showToast(message: StringFormattingError.unknown.description)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - findCurrentAddress
    private func findCurrentAddress() {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: InitialValue.localIdentifier)
        let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { place, _ in
            if let address: [CLPlacemark] = place {
                guard let city = address.last?.administrativeArea, let road = address.last?.thoroughfare else {
                    return
                }
                self.currentAddress = "\(city) \(road)"
            }
        }
    }
}

// MARK: - CLLocationManager
extension ViewController: CLLocationManagerDelegate {
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        searchCurrentLocation()
    }
    
    private func searchCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        setUpData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showToast(message: StringFormattingError.notAllowedLocationService.description)
        setUpData()
    }
}

// MARK: - ToastMessage
extension UIViewController {
    func showToast(message : String) {
        let labelWidth: CGFloat = 250
        let labelHeight: CGFloat = 35
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - labelWidth/2, y: self.view.frame.size.height-50, width: labelWidth, height: labelHeight))
        
        toastLabel.backgroundColor = .gray
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
