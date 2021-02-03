//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/27.
//

enum HTTPMethod: String, CustomStringConvertible {
    case get
    case post
    case put
    case patch
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
    
    func makeContentType(boundary: String) -> String {
        switch self {
        case .get, .delete, .put:
            return "application/json"
        case .patch, .post:
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
