//
//  DateFormat.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/16.
//

import Foundation

struct DateFormat {
    func convertFormat(unixTimeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy. MM. dd." 
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
}
