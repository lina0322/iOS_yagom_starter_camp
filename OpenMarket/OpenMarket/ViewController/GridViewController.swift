//
//  GridViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class GridViewController: UIViewController {
    var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productList = OpenMarketData.shared.productList
        self.view.backgroundColor = .brown
    }
}
