//
//  ErrorCase.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import Foundation

enum ErrorCase: Error {
    case decodingFailure
    case wrongData
    case cellError
}

extension ErrorCase: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "Decoding fail"
        case .wrongData:
            return "Wrong data"
        case .cellError:
            return "Cell error"
        }
    }
}
