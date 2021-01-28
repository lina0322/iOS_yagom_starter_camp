//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    let listViewController = ListViewController()
    let gridViewController = GRIDViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        addChild(listViewController)
        addChild(gridViewController)
        
        self.view.addSubview(listViewController.view)
        self.view.addSubview(gridViewController.view)
        
        listViewController.view.frame = self.view.bounds
        gridViewController.view.frame = self.view.bounds
        gridViewController.view.isHidden = true
    }
}

