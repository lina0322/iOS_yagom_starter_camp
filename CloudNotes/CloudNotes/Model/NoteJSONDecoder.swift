//
//  NoteJSONDecoder.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

struct NoteJSONDecoder {
    static var noteList: [Note] = []
    
    static func decodeData(_ data: Data) {
        do {
            self.noteList = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            debugPrint(NoteError.decodingFailure.localizedDescription)
        }
    }
}
