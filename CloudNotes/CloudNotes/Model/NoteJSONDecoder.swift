//
//  JSONDecoder.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

struct NoteJSONDecoder {
    let jsonDecoder = JSONDecoder()
    var notes: [Note] = []
    
    mutating func decodeData() {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return
        }
        do {
            self.notes = try jsonDecoder.decode([Note].self, from: dataAsset.data)
        } catch {
            debugPrint("Error")
        }
    }
}
