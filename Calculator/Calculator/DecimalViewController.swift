//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DecimalViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    var isPositive: Bool = true
    
    override func viewDidLoad() {
        valueLabel.text = Constants.zero
    }
    
    @IBAction func togglePlusMinus() {
        guard let labelText = valueLabel.text else { return }
        
        if isPositive {
            isPositive = false
            valueLabel.text = "-" + labelText
        } else {
            isPositive = true
            valueLabel.text?.removeFirst()
        }
    }
    
    @IBAction func reset() {
        DecimalCalculator.common.allClear()
        valueLabel.text = Constants.zero
        isPositive = true
    }
}

