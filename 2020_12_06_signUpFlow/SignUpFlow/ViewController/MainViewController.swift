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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UserInformation.common.recentId = ""
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
            return statusMessageLabel.changeText(to: .disableSignIn)
        }
        successSigIn()
    }
    
    private func successSigIn() {
        statusMessageLabel.changeText(to: .empty)
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
            statusMessageLabel.changeText(to: .enterId)
            return false
        }
        guard passwordTextField.isFilled() else {
            statusMessageLabel.changeText(to: .enterPassword)
            return false
        }
        return true
    }

    private func setUpIdPasswordField() {
        idTextField.text = UserInformation.common.recentId
        passwordTextField.text = ""
        statusMessageLabel.changeText(to: .empty)
    }
}

extension UITextField {
    func isFilled() -> Bool {
        guard let text = self.text, text.isEmpty == false else { return false }
        return true
    }
}

extension UILabel {
    func changeText(to message: Message) {
        self.text = message.rawValue
    }
}
