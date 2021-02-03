//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    @IBOutlet private var textFileds: [UITextField]!
    @IBOutlet private var descriptionView: UITextView!
    @IBOutlet private var imageCountLabel: UILabel!
    private let cancelButton = UIButton()
    private var navigationTitle = String.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigatinbar()
    }
    
    @IBAction func touchUpAddImageButton() {
        
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
//
//extension ProductRegistrationViewController: UITextViewDelegate, UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case idTextField:
//            passwordTextField.becomeFirstResponder()
//        case passwordTextField:
//            confirmationPasswordField.becomeFirstResponder()
//        case confirmationPasswordField:
//            introductionTextView.becomeFirstResponder()
//        default:
//            break
//        }
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        changeNextButtonStatus()
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        changeNextButtonStatus()
//    }
//}
