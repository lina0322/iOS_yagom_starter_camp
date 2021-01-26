import Foundation

enum CustomError: Error {
    case zziroError
}
class OpenMarketAPIManager {
    static let shared = OpenMarketAPIManager()
    
    private init() {}
    
    func fetchData(completionHandler: @escaping (Result<Data, StringFormattingError>) -> Void ) {
        guard let url = URL(string: "https://camp-open-market.herokuapp.com/items/1") else {
            // 에러핸들링
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.GET.rawValue
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                //에러 핸들링
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //에러 핸들링
                return
            }
            if let data = data {
                completionHandler(.success(data))
                return
            } else {
                completionHandler(.failure(.wrongData))
            }
        }
        task.resume()
    }
}

struct OpenMarketJSONDecoder {
    static let jsonDecoder = JSONDecoder()

    static func decodeData() {
        OpenMarketAPIManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                do {
                    APIResponse.data = try jsonDecoder.decode([ProductList].self, from: data)
                } catch DecodingError.dataCorrupted(let context) {
                    print("데이터가 손상되었거나 유효하지 않습니다.")
                    print(context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
                } catch DecodingError.keyNotFound(let codingkey, let context) {
                    print("주어진 키를 찾을수 없습니다.")
                    print(codingkey.intValue ?? Optional(nil)! , codingkey.stringValue , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("주어진 타입과 일치하지 않습니다.")
                    print(type.self , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("예상하지 않은 null 값이 발견되었습니다.")
                    print(type.self , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
                } catch {
                    print("그외 에러가 발생했습니다.")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

