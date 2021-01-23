//
//  WeatherForecast - ViewController.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/18.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var currentWeather: Weather?
    private var forecast: ForecastList?
    private var currentAddress: String = String.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
    }
    
    /// 현재 날씨, 일기 예보 데이터를 저장하고, 위치 정보를 한국어 주소로 변환
    private func configureData(for location: CLLocation) {
        updateCurrentWeater(of: location)
        updateForecast(of: location)
        findCurrentAddress(of: location)
    }
    
    private func updateCurrentWeater(of location: CLLocation) {
        let jsonDecoder = WeatherAPIJSONDecoder<Weather>()
        jsonDecoder.updateData(apiType: .currentWeather, location: location) { result in
            switch result {
            case .success(let data):
                self.currentWeather = data
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showToast(message: "\(error)")
                }
            }
        }
    }
    
    private func updateForecast(of location: CLLocation) {
        let jsonDecoder = WeatherAPIJSONDecoder<ForecastList>()
        jsonDecoder.updateData(apiType: .forecast, location: location) { result in
            switch result {
            case .success(let data):
                self.forecast = data
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showToast(message: "\(error)")
                }
            }
        }
    }
    
    // MARK: - findCurrentAddress
    private func findCurrentAddress(of location: CLLocation) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: InitialValue.localIdentifier)
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { place, _ in
            guard let address: [CLPlacemark] = place, let city = address.last?.administrativeArea, let road = address.last?.thoroughfare else {
                return
            }
            self.currentAddress = "\(city) \(road)"
        }
    }
}

// MARK: - CLLocationManager
extension ViewController: CLLocationManagerDelegate {
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            showToast(message: StringFormattingError.notAllowedLocationService.description)
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate: CLLocation = locations.last else {
            return
        }
        configureData(for: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showToast(message: StringFormattingError.notAllowedLocationService.description)
        let coordinate = CLLocation(latitude: InitialValue.namsanLatitude, longitude: InitialValue.namsanLongitude)
        configureData(for: coordinate)
    }
}
