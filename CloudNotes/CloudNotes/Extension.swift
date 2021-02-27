//
//  DateFormat.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/16.
//

import Foundation

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
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}

extension String {
    static let empty = ""
    static let newLine = "\n"
}
