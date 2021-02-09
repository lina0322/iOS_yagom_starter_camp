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
    @IBOutlet weak var confirmationPasswordField: UITextField!
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
        
        setUpImageViewTap()
        setUpPasswordSecure()
        setUpKeyboardDoneButton()
    }
    
    private func changeNextButtonStatus() {
        guard idTextField.isFilled(),
              isValidID(idTextField),
              passwordTextField.isFilled(),
              isValidPassword(passwordTextField),
              confirmationPasswordField.isFilled(),
              isPasswordSame(passwordTextField, as: confirmationPasswordField),
              introductionTextView.isFilled(),
              profileImage.image != nil else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
        saveTempData()
    }
    
    private func isValidID(_ textField: UITextField) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        guard let id = textField.text,
              NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id),
              UserInformation.common.userDirectory[id] == nil else {
            idTextField.textColor = .red
            return false
        }
        idTextField.textColor = .black
        return true
    }
    
    private func isValidPassword(_ textField: UITextField) -> Bool {
        let regex = "[\\S]{8,}"
        guard let password = textField.text,
              NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password) else {
            passwordTextField.textColor = .red
            return false
        }
        passwordTextField.textColor = .black
        return true
    }
    
    private func isPasswordSame(_ textField: UITextField, as anoterTextField: UITextField) -> Bool {
        guard textField.text == anoterTextField.text else {
            passwordTextField.textColor = .red
            confirmationPasswordField.textColor = .red
            return false
        }
        passwordTextField.textColor = .black
        confirmationPasswordField.textColor = .black
        return true
    }
    
    private func saveTempData() {
        UserInformation.common.id = idTextField.text
        UserInformation.common.password = passwordTextField.text
        UserInformation.common.profileImage = profileImage.image
        UserInformation.common.introduction = introductionTextView.text
    }
    
    private func setUpImageViewTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showImagePickerActionSheet))
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        profileImage.isUserInteractionEnabled = true
    }
    
    private func setUpPasswordSecure() {
        passwordTextField.isSecureTextEntry = true
        confirmationPasswordField.isSecureTextEntry = true
    }
    
    private func setUpKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapView(_:)))
        
        toolBarKeyboard.items = [flexibleSpace, doneButton]
        introductionTextView.inputAccessoryView = toolBarKeyboard
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func showImagePickerActionSheet() {
        self.view.endEditing(true)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumButton = UIAlertAction(title: ImageSelect.album.rawValue, style: .default) {
            _ in self.openAlbum()
        }
        let cameraButton = UIAlertAction(title: ImageSelect.camera.rawValue, style: .default) {
            _ in self.openCamera()
        }
        let cancelButton = UIAlertAction(title: ImageSelect.cancel.rawValue, style: .cancel, handler: nil)
        
        actionSheet.addAction(albumButton)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func openAlbum() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImage.image = image
        }
        changeNextButtonStatus()
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case idTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmationPasswordField.becomeFirstResponder()
        case confirmationPasswordField:
            introductionTextView.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeNextButtonStatus()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        changeNextButtonStatus()
    }
}

extension UITextView {
    func isFilled() -> Bool {
        guard let text = self.text, text.isEmpty == false else { return false }
        return true
    }
}
