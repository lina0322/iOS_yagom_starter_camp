//
//  NoteError.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/16.
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
            return "디코딩에 실패했습니다."
        case .wrongData:
            return "잘못된 데이터입니다."
        }
    }
}
