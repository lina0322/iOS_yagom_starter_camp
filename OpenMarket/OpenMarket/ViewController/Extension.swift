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
    func loadNextPage(for view: Reloadable?, completionHandler: @escaping (Result<Bool, OpenMarketError>) -> ()) {
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
    
    func showAlert(about message: String) {
        let alret = UIAlertController(title: message, message: "어플을 다시 실행시켜주세요.\n오류가 반복된다면 관리자에에게 문의해주세요.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: .none)
        
        alret.addAction(cancelButton)
        present(alret, animated: true, completion: nil)
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
