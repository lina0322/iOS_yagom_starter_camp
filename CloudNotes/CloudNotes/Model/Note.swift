//
//  Note.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import Foundation

struct Note: Codable {
    let title: String
    let body: String
    private let lastModified: Int
    var lastModifiedDate: String {
        return DateFormatter.convertToUserLocaleString(unixTimeStamp: lastModified)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}
