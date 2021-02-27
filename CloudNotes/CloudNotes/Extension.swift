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
        guard let locale = Locale.autoupdatingCurrent.collatorIdentifier else {
            return String.empty
        }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: locale)
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

extension String {
    static let empty = ""
    static let newLine = "\n"
}
