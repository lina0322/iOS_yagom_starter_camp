//
//  Extension.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

protocol Reloadable {
    func reloadData()
}

extension UITableView: Reloadable {}

extension UICollectionView: Reloadable {}

extension UIViewController {
    func loadPage(for view: Reloadable?, completionHandler: @escaping (Result<Bool, OpenMarketError>) -> ()) {
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: OpenMarketData.shared.currentPage)) { result in
            switch result {
            case .success(let data):
                if data.items.count == 0 {
                    completionHandler(.success(false))
                } else {
                    OpenMarketData.shared.productList.append(contentsOf: data.items)
                    OpenMarketData.shared.currentPage += 1
                    
                    completionHandler(.success(true))
                }
                if let view = view {
                    DispatchQueue.main.async {
                        view.reloadData()
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func showSuccessAlert(about message: String) {
        let alert = UIAlertController(title: message, message: String.empty, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: UIString.confirm, style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(about title: String, message: String = UIString.warning) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: UIString.confirm, style: .cancel, handler: .none)
        
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
