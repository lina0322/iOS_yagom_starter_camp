//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    let listViewController = ListViewController()
    let gridViewController = GridViewController()
    let segmentedControl = UISegmentedControl()
    let productRegistrationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentedControl()
        setUpNavigationBar()
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
    
    private func setSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "LIST", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "GRID", at: 1, animated: false)
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
    
    private func setUpNavigationBar() {
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = productRegistrationButton
    }
}

