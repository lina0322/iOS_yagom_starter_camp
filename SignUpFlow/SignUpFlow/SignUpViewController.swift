//
//  SecondViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var profileImage: UIImage!
    
    @IBAction func touchUpImage(_ sender: UIImage) {
       pickImage()
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func checkPassword() {
        guard passwordTextField.text == checkPasswordField.text else {
            return
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}
