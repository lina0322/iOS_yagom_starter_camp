//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    let listViewController = ListViewController()
    let gridViewController = GridViewController()
    
    let segmentedControlTitle = ["LIST", "GRID"]
    let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setSegmentedControl()
    }
    
    private func setSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    @objc private func didTapSegmentedControl(segmentedControl: UISegmentedControl) {
        listViewController.view.isHidden = true
        gridViewController.view.isHidden = true
        
        if segmentedControl.selectedSegmentIndex == 0 {
            listViewController.view.isHidden = false
        }
        else {
            gridViewController.view.isHidden = false
        }
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

