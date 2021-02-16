//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let noteTableViewController = NoteTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    private func setUpView() {
        addChild(noteTableViewController)
        self.view.addSubview(noteTableViewController.view)
        noteTableViewController.didMove(toParent: self)
        noteTableViewController.view.frame = self.view.bounds
    }
}

