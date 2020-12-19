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
    
    @IBAction func touchUpNumber(_ sender: UIButton) {
        guard var labelText = valueLabel.text else { return }
        if isPositive && labelText.count >= 11 { return }
        if isPositive == false && labelText.count >= 12 { return }
        
        if labelText == Constants.zero {
            labelText = Constants.empty
        } else if labelText == Constants.minusZero {
            labelText = Constants.minus
        }
        labelText = addComma(labelText)
        valueLabel.text = labelText + String(sender.tag)
    }
    
    private func addComma(_ labelText: String) -> String {
        var changedText: String = labelText
        
        if (isPositive && labelText.count == 3) || (isPositive && labelText.count == 7) ||
            (isPositive  == false && labelText.count == 4) || (isPositive == false && labelText.count == 8)   {
            changedText = labelText + Constants.comma
        }
        return changedText
    }
    
    @IBAction func reset() {
        DecimalCalculator.common.allClear()
        valueLabel.text = Constants.zero
        isPositive = true
    }
}

