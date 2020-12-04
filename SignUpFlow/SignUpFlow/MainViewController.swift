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
        
        passwordTextField.isSecureTextEntry = true
        changeStatusMessage(to: .empty)
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
        guard idTextField.isFilled() else {
            changeStatusMessage(to: .enterId)
            return
        }
        
        guard passwordTextField.isFilled() else {
            changeStatusMessage(to: .enterPassword)
            return
        }
        
        changeStatusMessage(to: .disableSignIn)
    }
    
    private func changeStatusMessage(to message: Message) {
        statusMessageLabel.text = message.rawValue
    }
}

extension UITextField {
    func isFilled() -> Bool {
        guard let text = self.text else { return false }
        if text.isEmpty { return false }
        return true
    }
}
