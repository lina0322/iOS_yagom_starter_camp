//
//  SecondViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    let imagePicker = UIImagePickerController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(pickImage))
     
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        profileImage.isUserInteractionEnabled = true
       
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        inactivateButton(nextButton)
    }
    
    func checkCanGoNext() {
        guard isFullfill(textField: idTextField, passwordTextField, checkPasswordField),
              profileImage.image != nil,
              introductionTextView.text != "" else {
            return inactivateButton(nextButton)
        }
        
        guard checkPasswordField.text == passwordTextField.text else {
            passwordTextField.textColor = .red
            checkPasswordField.textColor = .red
            return inactivateButton(nextButton)
        }
        
        passwordTextField.textColor = .black
        checkPasswordField.textColor = .black
        activateButton(nextButton)
    }
    
    func activateButton(_ button: UIButton) {
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.isEnabled = true
    }
    
    func inactivateButton(_ button: UIButton) {
        button.isEnabled = false
        button.setTitleColor(.systemGray, for: .normal)
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func pickImage() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
        }
        checkCanGoNext()
        dismiss(animated: true, completion: nil)
    }
}
