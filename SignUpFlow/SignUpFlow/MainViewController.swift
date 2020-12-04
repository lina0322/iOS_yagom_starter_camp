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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setUpIdPasswordField()
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
    
    private func signIn() {
        guard isAllFull() else {
            return
        }
        guard isVaild(id: idTextField.text ?? "",
                      password: passwordTextField.text ?? "") else {
            return changeStatusMessage(to: .disableSignIn)
        }
        successSigIn()
    }
    
    private func successSigIn() {
        changeStatusMessage(to: .empty)
        performSegue(withIdentifier: "SignInView", sender: nil)
    }
    
    private func isVaild(id: String, password: String) -> Bool {
        guard let user = UserInformation.common.userDirectory[id],
              user.password == password else {
            return false
        }
        return true
    }
    
    private func isAllFull() -> Bool {
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
    
    func setUpIdPasswordField() {
        idTextField.text = UserInformation.common.recentId
        passwordTextField.text = ""
        changeStatusMessage(to: .empty)
    }
}

extension UITextField {
    func isFilled() -> Bool {
        guard let text = self.text else { return false }
        if text.isEmpty { return false }
        return true
    }
}
