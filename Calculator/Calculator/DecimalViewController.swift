//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DecimalViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
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
    
    @IBAction func touchUpNumber(_ sender: UIButton) {
        guard var labelText = valueLabel.text else { return }
        if isPositive && labelText.count >= 9 { return }
        if isPositive == false && labelText.count >= 10 { return }
        
        if labelText == "0" {
            labelText = ""
        } else if labelText == "-0" {
            labelText = "-"
        }
        valueLabel.text = labelText + String(sender.tag)
    }
    
    @IBAction func reset() {
        DecimalCalculator.common.allClear()
        valueLabel.text = Constants.zero
        isPositive = true
    }
}

