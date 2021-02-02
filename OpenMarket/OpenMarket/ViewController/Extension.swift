//
//  Extension.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

extension UIViewController {
    func loadNextPage(completionHandler: @escaping (Result<Bool, OpenMarketError>) -> ()) {
        let page = OpenMarketData.shared.tableViewCurrentPage
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: page)) { result in
            switch result {
            case .success(let data):
                if data.items.count == 0 {
                    completionHandler(.success(false))
                } else {
                    OpenMarketData.shared.tableViewProductList.append(contentsOf: data.items)
                    OpenMarketData.shared.tableViewCurrentPage += 1
                    completionHandler(.success(true))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
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
