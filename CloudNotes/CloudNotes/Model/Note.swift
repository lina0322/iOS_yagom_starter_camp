//
//  Note.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/16.
//

import UIKit

struct Note: Decodable {
    let title: String
    let body: String
    private let lastModified: Int
    var lastModifiedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(lastModified))
        let dateString = DateFormatter.userLocale.string(from: date)
        return dateString
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
