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
        
        setUpImageViewTap()
        setUpPasswordSecure()
        setKeyboardDoneButton()
        nextButton.isEnabled = false
    }
    
    private func checkCanGoNext() {
        guard idTextField.isFilled(),
              passwordTextField.isFilled(),
              checkPasswordField.isFilled(),
              introductionTextView.isFilled(),
              profileImage.image != nil,
              isPasswordSame() else {
            nextButton.isEnabled = false
            return
        }
        
        nextButton.isEnabled = true
    }
    
    private func isPasswordSame() -> Bool {
        guard checkPasswordField.text == passwordTextField.text else {
            passwordTextField.textColor = .red
            checkPasswordField.textColor = .red
            nextButton.isEnabled = false
            return false
        }
        passwordTextField.textColor = .black
        checkPasswordField.textColor = .black
        return true
    }
    
    private func setUpImageViewTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showActionSheet))
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        profileImage.isUserInteractionEnabled = true
    }
    
    private func setUpPasswordSecure() {
        passwordTextField.isSecureTextEntry = true
        checkPasswordField.isSecureTextEntry = true
    }
    
    private func setKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tapView(_:)))
        
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
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumButton = UIAlertAction(title: ImageSelect.album.rawValue, style: .default) {
            _ in self.openAlbum()
        }
        let cameraButton = UIAlertAction(title: ImageSelect.cancel.rawValue, style: .default) {
            _ in self.openCamera()
        }
        let cancelButton = UIAlertAction(title: ImageSelect.cancel.rawValue, style: .cancel, handler: nil)
        
        actionSheet.addAction(albumButton)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openAlbum() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
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
