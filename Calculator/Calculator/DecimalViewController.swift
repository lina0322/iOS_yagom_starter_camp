//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DecimalViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    var isPositive: Bool = true
    var isIntegerNumber: Bool = true
    
    override func viewDidLoad() {
        valueLabel.text = Constants.zero
    }
    
    @IBAction func togglePlusMinus() {
        guard let labelText = valueLabel.text else { return }
        
        if isPositive {
            isPositive = false
            valueLabel.text = Constants.minus + labelText
        } else {
            isPositive = true
            valueLabel.text?.removeFirst()
        }
    }
    
    @IBAction func addDot() {
        if isIntegerNumber == true {
            guard let labelText = valueLabel.text else { return }
            valueLabel.text = labelText + Constants.dot
            isIntegerNumber = false
        }
    }
    
    @IBAction func touchUpNumber(_ sender: UIButton) {
        guard var labelText = valueLabel.text else { return }
        let NotNumberCount = countNotNumber(labelText)
        guard labelText.count < 9 + NotNumberCount else { return }
        
        if labelText == Constants.zero {
            labelText = Constants.empty
        } else if labelText == Constants.minusZero {
            labelText = Constants.minus
        }
        valueLabel.text = labelText + String(sender.tag)
        if isIntegerNumber { valueLabel.text = addComma(valueLabel.text!) }
    }
    
    private func addComma(_ labelText: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 8
        
        var changedText = labelText.components(separatedBy: Constants.comma).joined()
        guard let number = Double(changedText) else { return Constants.zero }
        changedText = numberFormatter.string(from: NSNumber(value: number))!
        return changedText
    }
    
    private func countNotNumber(_ labelText: String) -> Int {
        var count: Int = 0
        for element in labelText {
            let textElement = String(element)
            if textElement == Constants.minus  || textElement ==  Constants.comma || textElement ==  Constants.dot {
                count += 1
            }
        }
        return count
    }
    
    @IBAction func reset() {
        DecimalCalculator.common.allClear()
        valueLabel.text = Constants.zero
        isPositive = true
        isIntegerNumber = true
    }
}

