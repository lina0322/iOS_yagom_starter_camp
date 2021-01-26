import Foundation

enum StringFormattingError: Error, CustomStringConvertible {
    case wrongURL
    case wrongURLRequest
    case severConnectionFailure
    case wrongData
    case decodingFailure
    case unknown

    var description: String {
        switch self {
        case .wrongURL:
            return "잘못된 URL입니다."
        case .wrongURLRequest:
            return "잘못된 요청입니다."
        case .severConnectionFailure:
            return "서버와의 연결에 실패하였습니다."
        case .wrongData:
            return "잘못된 데이터입니다."
        case .decodingFailure:
            return "디코딩에 실패했습니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
