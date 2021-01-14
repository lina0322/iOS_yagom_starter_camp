//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    @IBOutlet var judgingClients: [UILabel]!
    @IBOutlet var currentClients: [UILabel]!
    @IBOutlet var waitingClients: [UILabel]!
    @IBOutlet weak var addingClientsButton: UIButton!
    @IBOutlet weak var allClearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

