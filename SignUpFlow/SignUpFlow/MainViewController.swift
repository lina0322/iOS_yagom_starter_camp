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
            touchUpSignIn(nil)
        }
        return true
    }
    
    @IBAction func touchUpSignIn(_ sender: UIButton?) {
        showCanNotSignInAlert()
    }
    
    func showCanNotSignInAlert() {
        let alert = UIAlertController(title: nil, message: "로그인 할 수 없습니다.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

