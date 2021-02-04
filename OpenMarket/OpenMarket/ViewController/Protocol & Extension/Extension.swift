//
//  Extension.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

extension UIViewController {
    func showErrorAlert(about title: String, message: String = OpenMarketString.warning) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: OpenMarketString.confirm, style: .cancel, handler: .none)
        
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    func configureConstraintToSafeArea(for object: UIView) {
        object.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(object)
        
        NSLayoutConstraint.activate([
            object.topAnchor.constraint(equalTo: safeArea.topAnchor),
            object.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            object.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            object.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension Int {
    func addComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let changedText = numberFormatter.string(from: NSNumber(value: self)) else {
            return String.empty
        }
        return changedText
    }
}

extension String {
    static let empty = ""
}

extension UITextView {
    func isFilled() -> Bool {
        guard let text = self.text, text.isEmpty == false else { return false }
        return true
    }
}
