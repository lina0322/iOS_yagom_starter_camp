//
//  Insertable.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/02/04.
//

import Foundation

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
            let lastCount = view.numberOfRows(inSection: 0)
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
