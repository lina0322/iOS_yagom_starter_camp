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
    
    @objc func valueChangedDatePicker(_ sender: UIDatePicker) {
        let date = sender.date
        
        changeDataLabelText(to: date)
        changeNextButtonStatus()
        self.view.endEditing(true)
    }
    
    private func changeDataLabelText(to date: Date) {
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
        
        do {
            try UserInformation.common.addNewUser()
            if let newID = UserInformation.common.id {
                UserInformation.common.recentId = newID
            }
            UserInformation.common.clearTempData()
            dismiss(animated: true, completion: nil)
        } catch {
            systemAlert()
        }
    }
    
    private func isValidPhoneNumber() -> Bool {
        let regex = "^01([0-9]{8,9})$"
        guard let phoneNumber = phoneNumberTextField.text,
              NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phoneNumber) else {
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
            changeDataLabelText(to: date)
        }
    }
    
    private func setUpDatePicker() {
        datePicker.timeZone = NSTimeZone.local
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(valueChangedDatePicker(_:)), for: .valueChanged)
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
    
    @IBAction func touchUpCancelButton() {
        saveTempData()
        popToPreviousPage()
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

extension UIViewController {
    func systemAlert() {
        let alert = UIAlertController(title: "", message: "회원가입에 실패하였습니다. 확인 후 다시 시도해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
