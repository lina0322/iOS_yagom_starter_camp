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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(pickImage))
     
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        profileImage.isUserInteractionEnabled = true

        passwordTextField.isSecureTextEntry = true
        checkPasswordField.isSecureTextEntry = true
        
        nextButton.isEnabled = false
    }
    
    func checkCanGoNext() {
        guard idTextField.isFilled(),
              passwordTextField.isFilled(),
              checkPasswordField.isFilled(),
              introductionTextView.isFilled(),
              profileImage.image != nil else {
            nextButton.isEnabled = false
            return
        }
        
        guard checkPasswordField.text == passwordTextField.text else {
            passwordTextField.textColor = .red
            checkPasswordField.textColor = .red
            nextButton.isEnabled = false
            return
        }
        
        passwordTextField.textColor = .black
        checkPasswordField.textColor = .black
        nextButton.isEnabled = true
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func pickImage() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImage.image = image
        }
        checkCanGoNext()
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextViewDelegate, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case idTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            checkPasswordField.becomeFirstResponder()
        case checkPasswordField:
            introductionTextView.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkCanGoNext()
    }
  
    func textViewDidEndEditing(_ textView: UITextView) {
        checkCanGoNext()
    }
}

extension UITextView {
    func isFilled() -> Bool {
        guard let text = self.text else { return false }
        if text.isEmpty { return false }
        return true
    }
}
