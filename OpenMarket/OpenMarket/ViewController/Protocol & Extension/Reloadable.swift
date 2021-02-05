//
//  Reloadable.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/02/04.
//

import UIKit

protocol Reloadable {
    func reloadData()
}

extension UITableView: Reloadable {}

extension UICollectionView: Reloadable {}

