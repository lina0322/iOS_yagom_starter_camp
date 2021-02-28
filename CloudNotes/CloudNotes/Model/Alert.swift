//
//  Alert.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/28.
//

import UIKit

struct Alert {
    static func show(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: NoteString.confirmButton, style: .default, handler: nil)
        alert.addAction(confirmButton)
        alert.present(alert, animated: true, completion: nil)
    }
}
