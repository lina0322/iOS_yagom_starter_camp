//
//  WeatherError.swift
//  WeatherForecast
//
//  Created by 리나 on 2021/01/19.
//

enum StringFormattingError: Error, CustomStringConvertible {
    case notAllowedLocationService
    case failedRequest
    case decodingFailure
    case failedConversion
    case unknown

    var description: String {
        switch self {
        case .notAllowedLocationService:
            return "위치 정보를 가져오지 못했습니다.\n 기본 위치로 날씨를 조회합니다."
        case .failedRequest:
            return "서버에서 날씨 정보를 가져오지 못했습니다."
        case .decodingFailure:
            return "날씨 정보를 변환하지 못했습니다."
        case .failedConversion:
            return "주소를 변환하지 못했습니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
