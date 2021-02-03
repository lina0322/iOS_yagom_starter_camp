//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
// TODO! password란에 secure설정! 지금 키체인 때문에 꺼놓음

import UIKit

final class ProductRegistrationViewController: UIViewController {
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var descriptionView: UITextView!
    @IBOutlet private var imageCountLabel: UILabel!
    private let cancelButton = UIButton()
    var navigationTitle = String.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigatinbar()
        configureKeyboardDoneButton()
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
        textFields[2].inputAccessoryView = toolBarKeyboard
        textFields[3].inputAccessoryView = toolBarKeyboard
        textFields[4].inputAccessoryView = toolBarKeyboard
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
