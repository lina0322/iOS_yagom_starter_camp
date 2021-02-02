//
//  Data.swift
//  AutoLayoutStudy
//
//  Created by 리나 on 2021/01/12.
//

import Foundation

struct Data {
    static let list: [String] = ["bam", "glenn", "green", "innie", "jacob", "jake", "joons", "kkomal", "lasagna", "lina", "odongnamu", "sodae", "sole", "taetae", "zziro", "zziroro", "yagom", "jinie", "limwin94", "rythm", "delmaSong", "o-o-wl", "appleCEO", "cmindy", "daheenallwhite", "노래하는하리보"]
    static let sortedList = list.sorted()
    static let firstCharactors = Array(Set(list.map{ $0.first })).map{ String($0!) }.sorted()
}
