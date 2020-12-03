//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//  Todo: 전화번호 사이에 - 넣어주기

import UIKit

class SignUpDetailViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(onDidChangeDate(_:)), for: .valueChanged)
        
        doneButton.isEnabled = false
    }
    
    @objc func onDidChangeDate(_ sender: UIDatePicker) {
        let date = sender.date
        
        changeDateLabel(to: date)
    }
    
    func changeDateLabel(to date: Date) {
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
        checkCanFinish()
    }
    
    func checkCanFinish() {
        guard let phoneNumber = phoneNumberTextField.text,
              !phoneNumber.isEmpty,
              let dateOfbirth = dateLabel.text,
              !dateOfbirth.isEmpty else {
            doneButton.isEnabled = false
            return
        }
        doneButton.isEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popToPrev() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeSignUp() {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkCanFinish()
    }
}
