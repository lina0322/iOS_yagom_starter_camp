//
//  Reloadable.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/02/04.
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
}

extension UITableView: Reloadable {
    var isTableView: Bool {
        return true
    }
    var isCollectionView: Bool {
        return false
    }
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

