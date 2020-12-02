//
//  SignUpFlow - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            systemAlert()
        }
        return true
    }
    
    @IBAction func touchUpSignIn(_ sender: UIButton) {
        systemAlert()
    }
    
    func systemAlert() {
        if idTextField.text == "" {
            showAlert(about: "아이디를 입력해주세요.")
        } else if passwordTextField.text == "" {
            showAlert(about: "비밀번호를 입력해주세요.")
        } else {
            showAlert(about: "로그인 기능이 비활성화 되어있습니다.")
        }
    }
    
    func showAlert(about message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

