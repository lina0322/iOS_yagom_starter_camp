//
//  Extension.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

protocol Reloadable {
    var isTableView: Bool { get }
    var isCollectionView: Bool { get }
    
    func reloadData()
    
    func beginUpdates()
    func endUpdates()
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func numberOfRows(inSection section: Int) -> Int
    
    func insertItems(at indexPaths: [IndexPath])
}

protocol Insertable {
    func loadNextPage(for view: Reloadable?, completionHandler: @escaping (Result<Bool, OpenMarketError>) -> ())
    func reloadAllSection(view: Reloadable?)
    func reloadNewCell(view: Reloadable)
}

extension Insertable {
    func loadNextPage(for view: Reloadable?, completionHandler: @escaping (Result<Bool, OpenMarketError>) -> ()) {
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: OpenMarketData.shared.currentPage)) { result in
            switch result {
            case .success(let data):
                if data.items.count == 0 {
                    self.reloadAllSection(view: view)
                    completionHandler(.success(false))
                } else {
                    OpenMarketData.shared.productList.append(contentsOf: data.items)
                    OpenMarketData.shared.currentPage += 1
                    completionHandler(.success(true))
                    if let view = view {
                        self.reloadNewCell(view: view)
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func reloadAllSection(view: Reloadable?) {
        guard let view = view else {
            return
        }
        DispatchQueue.main.async {
            view.reloadData()
        }
    }
    
    func reloadNewCell(view: Reloadable) {
        DispatchQueue.main.async {
            let count = OpenMarketData.shared.productList.count
            print(count)
            let lastCount = view.numberOfRows(inSection: 0)
            print(lastCount)
            if view.isTableView {
                view.beginUpdates()
                for row in (lastCount)...(count - 1) {
                    let indexPath = IndexPath(row: row, section: 0)
                    view.insertRows(at: [indexPath], with: .none)
                }
                view.endUpdates()
            }
        }
    }
}

extension UITableView: Reloadable {
    var isTableView: Bool {
        return true
    }
    var isCollectionView: Bool {
        return false
    }
    
    func insertItems(at indexPaths: [IndexPath]) {}
}

extension UICollectionView: Reloadable {
    var isTableView: Bool {
        return false
    }
    var isCollectionView: Bool {
        return true
    }
    
    func beginUpdates() {}
    func endUpdates() {}
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {}
    func numberOfRows(inSection section: Int) -> Int { return 0 }
}

extension UIViewController {
    func showAlert(about message: String) {
        let alert = UIAlertController(title: message, message: "어플을 다시 실행시켜주세요.\n오류가 반복된다면 관리자에에게 문의해주세요.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: .none)
        
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
