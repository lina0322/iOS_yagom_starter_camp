//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//  Todo: 아이디 유효성 검사, 비밀번호랑 아이디 길이...? 전화번호 길이 확인, 첫페이지 비번;;

import UIKit

class SignUpDetailViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showTempData()
        checkCanFinish()
    }
    
    @objc func touchUpDatePicker(_ sender: UIDatePicker) {
        let date = sender.date
        
        changeDateLabel(to: date)
        checkCanFinish()
    }
    
    private func changeDateLabel(to date: Date) {
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
    }
    
    private func checkCanFinish() {
        guard phoneNumberTextField.isFilled(),
              dateLabel.isFilled() else {
            doneButton.isEnabled = false
            return
        }
        doneButton.isEnabled = true
    }
    
    @IBAction func completeSignUp() {
        saveTempData()
        UserInformation.common.addNewUser(userInformation: TempInformation.common)
        UserInformation.common.recentId = TempInformation.common.id ?? ""
        TempInformation.common.clearAll()
        dismiss(animated: true, completion: nil)
    }
   
    private func saveTempData() {
        if let phoneNumberField = phoneNumberTextField {
            if let phoneNumber = phoneNumberField.text {
                TempInformation.common.phoneNumber = phoneNumber
            }
        }
        if let selectDate = datePicker {
            TempInformation.common.dateOfBirth = selectDate.date
        }
    }

    private func showTempData() {
        if let phoneNumber = TempInformation.common.phoneNumber {
            phoneNumberTextField.text = phoneNumber
        }
        if let date = TempInformation.common.dateOfBirth {
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func dismissSignUpView() {
        TempInformation.common.clearAll()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popToPrev() {
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
        checkCanFinish()
    }
}

extension UILabel {
    func isFilled() -> Bool {
        guard let text = self.text else { return false }
        if text.isEmpty { return false }
        return true
    }
}
