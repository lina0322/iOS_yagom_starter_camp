//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
// TODO! password란에 secure설정! 지금 키체인 때문에 꺼놓음, 키보드때문에 가려지는것

import UIKit

final class ProductRegistrationViewController: UIViewController {
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var descriptionView: UITextView!
    @IBOutlet private var imageCountLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    private let cancelButton = UIButton()
    var navigationTitle = String.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configureNavigatinbar()
        configureKeyboardDoneButton()
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height + 150, right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @IBAction func touchUpAddImageButton() {
        
    }
    
    private func configureKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton))
        
        toolBarKeyboard.items = [flexibleSpace, doneButton]
        descriptionView.inputAccessoryView = toolBarKeyboard
        for textField in textFields {
            textField.inputAccessoryView = toolBarKeyboard
        }
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    private func configureNavigatinbar() {
        configureCancelButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.title = navigationTitle
    }
    
    private func configureCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductRegistrationViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTextFieldTage = textField.tag
        if currentTextFieldTage < 4 {
            textFields[currentTextFieldTage + 1].becomeFirstResponder()
        } else if currentTextFieldTage == 4 {
            descriptionView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let currentTextFieldTage = textField.tag
        if currentTextFieldTage < 4 {
            textFields[currentTextFieldTage + 1].becomeFirstResponder()
        } else if currentTextFieldTage == 4 {
            descriptionView.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFields[5].becomeFirstResponder()
    }
}
