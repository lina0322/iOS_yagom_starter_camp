//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DecimalViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    let decimalCalculator = DecimalCalculator()
    var isPositive: Bool = true
    var isIntegerNumber: Bool = true
    var isReseted: Bool = false
    var `operator`: String = Constants.empty
    
    override func viewDidLoad() {
        valueLabel.text = Constants.zero
    }
    
    @IBAction func togglePlusMinus() {
        guard let labelText = valueLabel.text else { return }
        
        if `operator` != Constants.empty {
            valueLabel.text = Constants.minusZero
            `operator` = Constants.empty
            isPositive = false
        } else if isPositive {
            isPositive = false
            valueLabel.text = Constants.minus + labelText
        } else {
            isPositive = true
            valueLabel.text?.removeFirst()
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            `operator` = "+"
        case 2:
            `operator` = "-"
        case 3:
            `operator` = "*"
        case 4:
            `operator` = "/"
        default:
            `operator` = "오류"
        }
    }
    
    @IBAction func touchUpEqual() {
        guard var labelText = valueLabel.text else { return }
        labelText = labelText.components(separatedBy: Constants.comma).joined()
        decimalCalculator.handleInput(labelText)
        
        decimalCalculator.handleInput("=")
        let text = addComma(decimalCalculator.resultValue)
        valueLabel.text = text
        reset()
        isReseted = true
    }
    
    @IBAction func touchUpNumber(_ sender: UIButton) {
        if isReseted { isReseted = false }
        
        if `operator` != Constants.empty {
            guard var labelText = valueLabel.text else { return }
            labelText = labelText.components(separatedBy: Constants.comma).joined()
            decimalCalculator.handleInput(labelText)
            decimalCalculator.handleInput(`operator`)
            `operator` = Constants.empty
            valueLabel.text = Constants.zero
        }

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
    
    @IBAction func addDot() {
        if isIntegerNumber == true {
            guard let labelText = valueLabel.text else { return }
            valueLabel.text = labelText + Constants.dot
            isIntegerNumber = false
        }
    }
    
    @IBAction func touchUpCancel() {
        reset()
        valueLabel.text = Constants.zero
    }
    
    private func reset() {
        decimalCalculator.allClear()
        isPositive = true
        isIntegerNumber = true
        `operator` = Constants.empty
    }
}

