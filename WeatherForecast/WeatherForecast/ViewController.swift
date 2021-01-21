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
    private var currentAddress: String = InitialValue.emptyString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocationManager()
    }
    
    /// 현재 날씨, 일기 예보 데이터를 저장하고, 위치 정보를 한국어 주소로 변환
    private func setUpData(latitude: Double, longitude: Double) {
        decodeCurrentWeaterFromAPI(latitude: latitude, longitude: longitude)
        decodeForecastFromAPI(latitude: latitude, longitude: longitude)
        findCurrentAddress(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - decode
    private func decodeCurrentWeaterFromAPI(latitude: Double, longitude: Double) {
        guard var urlRequest = WeatherAPIManager.shared.makeURLRequest(kind: .currentWeather, latitude: latitude, logitude: longitude) else {
            return
        }
        
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                return
            }
            do {
                self.currentWeather = try JSONDecoder().decode(Weather.self, from: data)
            } catch {
                self.showToast(message: StringFormattingError.decodingFailure.description)
            }
        }.resume()
    }
    
    private func decodeForecastFromAPI(latitude: Double, longitude: Double) {
        guard var urlRequest = WeatherAPIManager.shared.makeURLRequest(kind: .forecast, latitude: latitude, logitude: longitude) else {
            return
        }
        
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                return
            }
            do {
                self.forecast = try JSONDecoder().decode(ForecastList.self, from: data)
            } catch {
                self.showToast(message: StringFormattingError.decodingFailure.description)
            }
        }.resume()
    }
    
    // MARK: - findCurrentAddress
    private func findCurrentAddress(latitude: Double, longitude: Double) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: InitialValue.localIdentifier)
        let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
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
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        setUpData(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showToast(message: StringFormattingError.notAllowedLocationService.description)
        let latitude: Double = InitialValue.namsanLatitude
        let longitude: Double = InitialValue.namsanLongitude
        setUpData(latitude: latitude, longitude: longitude)
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
