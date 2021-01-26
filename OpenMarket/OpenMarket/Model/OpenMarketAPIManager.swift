import Foundation

struct OpenMarketAPIManager {
    enum APIType: CustomStringConvertible {
            case page
            case product
            
            var description: String {
                switch self {
                case .page:
                    return "items/"
                case .product:
                    return "item/"
                }
            }
        }

    private static let baseURL = "https://camp-open-market.herokuapp.com/"
    
    static func fetchData(about type: APIType, page number: Int,completionHandler: @escaping (Result<Data, StringFormattingError>) -> Void ) {
        guard var urlRequest = OpenMarketAPIManager.makeURLRequest(about: type, pageNumber: number) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        urlRequest.httpMethod = HTTPMethod.GET.rawValue
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                completionHandler(.failure(.severConnectionFailure))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                debugPrint(response.debugDescription)
                completionHandler(.failure(.severConnectionFailure))
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
    
    private static func makeURLRequest(about type: APIType, pageNumber: Int) -> URLRequest? {
        let absoluteURL = "\(baseURL)\(type)\(pageNumber)/"
        guard let url = URL(string: absoluteURL) else {
            debugPrint(StringFormattingError.wrongURL)
            return nil
        }
        return URLRequest(url: url)
    }
}


struct OpenMarketJSONDecoder<T: Decodable> {

    static func decodeData(about type: OpenMarketAPIManager.APIType, pageNumber: Int, completionHandler: @escaping (Result<T, StringFormattingError>) -> ()){
        let decoder = JSONDecoder()

        OpenMarketAPIManager.fetchData(about: type, page: pageNumber) { result in
            switch result {
            case .success(let data):
                do {
                    let productList = try decoder.decode(T.self, from: data)
                    completionHandler(.success(productList))
                } catch {
                    completionHandler(.failure(.decodingFailure))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
