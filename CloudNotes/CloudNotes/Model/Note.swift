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
    let lastModified: Int
    var lastModifiedDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(lastModified))
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
