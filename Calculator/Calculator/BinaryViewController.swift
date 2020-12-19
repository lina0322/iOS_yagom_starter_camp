//
//  BinaryViewController.swift
//  Calculator
//
//  Created by 임리나 on 2020/12/19.
//

import UIKit

class BinaryViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!

    var isPositive: Bool = true
    
    override func viewDidLoad() {
        valueLabel.text = "0"
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
        BinaryCalculator.common.allClear()
        valueLabel.text = Constants.zero
        isPositive = true
    }
    
    @IBAction func dismissBinaryCalculator() {
        dismiss(animated: true, completion: nil)
    }
}
