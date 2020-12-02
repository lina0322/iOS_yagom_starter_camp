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
        makeLabel(text: statusMessageLabel, to: .empty)
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
            makeLabel(text: statusMessageLabel, to: .enterId)
            return
        }
        
        guard isFullfill(textField: passwordTextField) else {
            makeLabel(text: statusMessageLabel, to: .enterPassword)
            return
        }
        
        makeLabel(text: statusMessageLabel, to: .disableSignIn)
    }
    
    func isFullfill(textField: UITextField) -> Bool {
        guard textField.text != "" else {
            return false
        }
        return true
    }
    
    func makeLabel(text label: UILabel, to message: Message) {
        label.text = message.rawValue
    }
}

