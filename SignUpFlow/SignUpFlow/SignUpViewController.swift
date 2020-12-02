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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var introductionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(pickImage))
     
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        profileImage.isUserInteractionEnabled = true
        
        inactivateButton(nextButton)
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 안되어있는 경우 라벨이나 palceholder에 표시하기
    @IBAction func makeEnableNextButton() {
        guard isFullfill(textField: idTextField, passwordTextField, checkPasswordField),
              profileImage.image != nil,
              introductionTextView.text != "" else {
            return print("뭔가안채워짐")
        }
        
        guard checkPasswordField.text == passwordTextField.text else {
            return print("비번다름")
        }
        
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
}

extension SignUpViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func pickImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
