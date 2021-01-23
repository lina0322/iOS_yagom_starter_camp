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
    
    // MARK: - Configure Data
    private func configureData(for location: CLLocation) {
        updateCurrentWeater(of: location)
        updateForecast(of: location)
        updateCurrentAddress(of: location)
    }
    
    private func updateCurrentAddress(of location: CLLocation) {
        AddressConverter.findCurrentAddress(of: location) { result in
            switch result {
            case .success(let data):
                self.currentAddress = data
            case .failure(let error):
                self.showToast(message: "\(error)")
            }
        }
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
