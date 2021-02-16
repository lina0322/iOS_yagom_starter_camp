//
//  NoteJSONDecoder.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/16.
//

import UIKit

struct NoteJSONDecoder {
    static func decodeData(_ data: Data) -> [Note]? {
        do {
            let decodeData = try JSONDecoder().decode([Note].self, from: data)
            return decodeData
        } catch {
            debugPrint(NoteError.decodingFailure.localizedDescription)
            return nil
        }
    }
}
