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
            signIn()
        }
        return false
    }
    
    @IBAction func touchUpSignIn(_ sender: UIButton?) {
        signIn()
    }
    
    func signIn() {
        guard isAllFull() else {
            return
        }
        // 아이디와 패스워드를 확인하고 맞으면 로그인하는 힘수 들어갈 자리
        // 만약 없는 아이디나 잘못된 패스워드이면 아래 문구 출력
        changeStatusMessage(to: .disableSignIn)
    }
    
    func isAllFull() -> Bool {
        guard idTextField.isFilled() else {
            changeStatusMessage(to: .enterId)
            return false
        }
        guard passwordTextField.isFilled() else {
            changeStatusMessage(to: .enterPassword)
            return false
        }
        return true
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
