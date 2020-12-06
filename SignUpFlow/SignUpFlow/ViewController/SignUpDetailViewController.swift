//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//

import UIKit

class SignUpDetailViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDatePicker()
        setUpKeyboardDoneButton()
        statusMessageLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTempData()
        changeNextButtonStatus()
    }
    
    @objc func touchUpDatePicker(_ sender: UIDatePicker) {
        let date = sender.date
        
        changeDateLabel(to: date)
        changeNextButtonStatus()
        self.view.endEditing(true)
    }
    
    private func changeDateLabel(to date: Date) {
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
    }
    
    private func changeNextButtonStatus() {
        guard phoneNumberTextField.isFilled(),
              isValidPhoneNumber(),
              dateLabel.isFilled() else {
            doneButton.isEnabled = false
            return
        }
        doneButton.isEnabled = true
    }
    
    @IBAction func completeSignUp() {
        saveTempData()
        UserInformation.common.addNewUser()
        UserInformation.common.recentId = UserInformation.common.id ?? ""
        UserInformation.common.clearTempData()
        dismiss(animated: true, completion: nil)
    }
    
    private func isValidPhoneNumber() -> Bool {
        guard let phoneNumber = phoneNumberTextField.text,
              phoneNumber.hasPrefix("01"),
              (phoneNumber.count == 11 || phoneNumber.count == 10),
              let _ = Int(phoneNumber) else {
            statusMessageLabel.changeText(to: .wrongNumber)
            return false
        }
        statusMessageLabel.changeText(to: .empty)
        return true
    }
    
    private func saveTempData() {
        if let phoneNumberField = phoneNumberTextField {
            if let phoneNumber = phoneNumberField.text {
                UserInformation.common.phoneNumber = phoneNumber
            }
        }
        if let selectDate = datePicker {
            UserInformation.common.dateOfBirth = selectDate.date
        }
    }
    
    private func showTempData() {
        if let phoneNumber = UserInformation.common.phoneNumber {
            phoneNumberTextField.text = phoneNumber
        }
        if let date = UserInformation.common.dateOfBirth {
            datePicker.date = date
            changeDateLabel(to: date)
        }
    }
    
    private func setUpDatePicker() {
        datePicker.timeZone = NSTimeZone.local
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(touchUpDatePicker(_:)), for: .valueChanged)
    }
    
    private func changeStatusMessage(to message: Message) {
        statusMessageLabel.text = message.rawValue
    }
    
    private func setUpKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton))
        
        toolBarKeyboard.items = [flexibleSpace, doneButton]
        phoneNumberTextField.inputAccessoryView = toolBarKeyboard
    }
    
    @objc override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @objc func touchUpDoneButton() {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissSignUpView() {
        UserInformation.common.clearTempData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popToPreviousPage() {
        saveTempData()
        
        guard let currentView = self.navigationController else {
            return
        }
        currentView.popViewController(animated: true)
    }
}

extension SignUpDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeNextButtonStatus()
    }
}

extension UILabel {
    func isFilled() -> Bool {
        guard let text = self.text else { return false }
        if text.isEmpty { return false }
        return true
    }
}
