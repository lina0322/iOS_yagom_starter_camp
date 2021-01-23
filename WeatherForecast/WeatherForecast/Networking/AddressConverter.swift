//
//   AddressConverter.swift
//  WeatherForecast
//
//  Created by 임리나 on 2021/01/23.
//

import CoreLocation

struct AddressConverter {
    static func findCurrentAddress(of location: CLLocation, result: @escaping (Result<String, StringFormattingError>) -> ()) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: InitialValue.localIdentifier)
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { place, _ in
            guard let address: [CLPlacemark] = place, let city = address.last?.administrativeArea, let road = address.last?.thoroughfare else {
                result(.failure(.failedConversion))
                return
            }
            let currentAddress = "\(city) \(road)"
            result(.success(currentAddress))
        }
    }
}
