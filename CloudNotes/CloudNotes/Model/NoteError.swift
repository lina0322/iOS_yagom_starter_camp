//
//  NoteError.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import Foundation

enum NoteError: Error {
    case decodingFailure
    case wrongData
}

extension NoteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "Decoding fail"
        case .wrongData:
            return "Wrong data"
        }
    }
}
