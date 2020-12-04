//
//  SignUpFlow - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// Todo: 전화번호 사이에 - 넣어주기, 전화번호 길이 확인, 자기소개랑 전화번호에 done키 같은거 만들어주기, 마지막 페이지 정보저장, 마지막페이지에서 첫번째 페이지로 아이디 넘겨주기

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    var newId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        changeLabelText(with: statusMessageLabel, to: .empty)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(newId)
        print("보여?")
        super.viewDidAppear(animated)
        idTextField.text = newId
        print(UserInformation.common.userDirectory)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        newId = ""
//        passwordTextField.text = ""
//    }
    
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
            changeLabelText(with: statusMessageLabel, to: .enterId)
            return
        }
        
        guard isFullfill(textField: passwordTextField) else {
            changeLabelText(with: statusMessageLabel, to: .enterPassword)
            return
        }
        
        changeLabelText(with: statusMessageLabel, to: .disableSignIn)
    }
    
    func changeLabelText(with label: UILabel, to message: Message) {
        label.text = message.rawValue
    }
}

extension UIViewController {
    func isFullfill(textField: UITextField...) -> Bool {
        for eachTextField in textField {
            guard let text = eachTextField.text else { return false }
            if text.isEmpty { return false }
        }
        return true
    }
}
