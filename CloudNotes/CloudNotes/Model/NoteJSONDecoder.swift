//
//  JSONDecoder.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import Foundation

struct JSONDecoder {
    let jsonDecoder = JSONDecoder()
    
    guard let dataAsset = NSDataAsset(name: "items") else {
    return
    }
    do {
    self.entryOfKorea = try jsonDecoder.decode([Note].self, from: dataAsset.data)
    } catch {
    debugPrint("Error")
    }
}
