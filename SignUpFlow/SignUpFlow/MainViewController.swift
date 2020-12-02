//
//  SignUpFlow - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        changeLabel(text: statusMessageLabel, to: .empty)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            touchUpSignIn(nil)
        }
        return false
    }
    
    @IBAction func touchUpSignIn(_ sender: UIButton?) {
        guard isFullfill(textField: idTextField) else {
            changeLabel(text: statusMessageLabel, to: .enterId)
            return
        }
        
        guard isFullfill(textField: passwordTextField) else {
            changeLabel(text: statusMessageLabel, to: .enterPassword)
            return
        }
        
        changeLabel(text: statusMessageLabel, to: .empty)
    }
    
    func isFullfill(textField: UITextField) -> Bool {
        guard textField.text != nil else {
            return false
        }
        return true
    }
    
    func changeLabel(text label: UILabel, to message: Message) {
        label.text = message.rawValue
    }
}

