//
//  ErrorCase.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import Foundation

enum ErrorCase: Error {
    case cellError
    case notSelectedNote
    case wrongURL
}

extension ErrorCase: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cellError:
            return "Cell error"
        case .notSelectedNote:
            return "선택된 노트가 없습니다."
        case .wrongURL:
            return "이동할 수 없습니다."
        }
    }
}
