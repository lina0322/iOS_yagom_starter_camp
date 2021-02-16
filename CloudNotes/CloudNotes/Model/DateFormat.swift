//
//  DateFormat.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/16.
//

import Foundation

struct DateFormat {
    func convertFormat(unixTimeStamp: Int) -> String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimeStamp))
        let locale = Locale.current.identifier
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: locale)
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
