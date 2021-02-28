//
//  DateFormat.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/16.
//

import Foundation

// MARK: - DateFormatter

extension DateFormatter {
    static func convertToUserLocaleString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        var locale = Locale.autoupdatingCurrent.identifier
        if let collatorLocale = Locale.autoupdatingCurrent.collatorIdentifier {
            locale = collatorLocale
        }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: locale)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

// MARK: - String

extension String {
    static let empty = ""
    static let newLine = "\n"
}
