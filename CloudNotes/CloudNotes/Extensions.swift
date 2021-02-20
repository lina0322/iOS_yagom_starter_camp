//
//  NoteDataFormatter.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/19.
//

import Foundation

extension DateFormatter {
    static let userLocale: DateFormatter = {
        let dateFormatter = DateFormatter()
        let locale = Locale.autoupdatingCurrent.identifier
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter
    }()
}

extension String {
    static let empty = ""
}
