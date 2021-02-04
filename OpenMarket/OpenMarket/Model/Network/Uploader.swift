//
//  Uploader.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

import Foundation

struct Uploader {
    static let boundary = URLRequestManager.boundary
    
    static func uploadData(by httpMethod: HTTPMethod = .post, product: Product, apiRequestType: APIRequestType, completionHandler: @escaping (Result<Any, OpenMarketError>) -> ()) {
        guard var urlRequest = URLRequestManager.makeURLRequest(for: httpMethod, about: apiRequestType) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        urlRequest.httpBody = makeHTTPBody(for: product)
        
        NetworkHandler().startLoad(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    static func deleteData(product: Product, apiRequestType: APIRequestType, completionHandler: @escaping (Result<Any, OpenMarketError>) -> ()) {
        guard var urlRequest = URLRequestManager.makeURLRequest(for: .delete, about: apiRequestType) else {
            completionHandler(.failure(.wrongURLRequest))
            return
        }
        
        encode(data: product) { result in
            switch result {
            case .success(let data):
                urlRequest.httpBody = data
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        NetworkHandler().startLoad(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    
    private static func makeHTTPBody(for product: Product) -> Data {
        var data = Data()
        
        for (parameter, value) in product.parameters {
            if let images = value as? [Data] {
                data.append(makeImageParameter(parameter, images: images))
            } else if let value = value {
                data.append(makeNormalParameter(parameter, value: value))
            }
        }
        data.appendString("--\(boundary)--\r\n")
        return data
    }
    
    private static func makeNormalParameter(_ parameter: String, value: Any) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
        if let value = value as? String {
            data.appendString(value)
        } else if let value = value as? Int {
            data.appendString(String(value))
        }
        data.appendString("\r\n")
        return data
    }
    
    private static func makeImageParameter(_ parameter: String, images: [Data]) -> Data {
        var data = Data()
        var imageIndex = 1
        
        for image in images {
            data.appendString("--\(boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image\(imageIndex).png\"\r\n")
            data.appendString("Content-Type: image/png\r\n\r\n")
            data.append(image)
            data.appendString("\r\n")
            imageIndex += 1
        }
        return data
    }
    
    private static func encode(data: Product,  completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            completionHandler(.success(encodedData))
        } catch {
            completionHandler(.failure(.encodingFailure))
        }
    }
}
