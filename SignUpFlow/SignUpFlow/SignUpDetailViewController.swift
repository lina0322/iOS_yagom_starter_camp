//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//  Todo: 아이디 유효성 검사, 비밀번호랑 아이디 길이...? 전화번호 길이 확인

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
        showSavePhoneNumber()
        showSaveDateOfBrith()
    }
    
    @objc func onDidChangeDate(_ sender: UIDatePicker) {
        let date = sender.date
        
        changeDateLabel(to: date)
    }
    
    private func changeDateLabel(to date: Date) {
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
        checkCanFinish()
    }
    
    private func checkCanFinish() {
        guard let phoneNumber = phoneNumberTextField.text,
              !phoneNumber.isEmpty,
              let dateOfbirth = dateLabel.text,
              !dateOfbirth.isEmpty else {
            doneButton.isEnabled = false
            return
        }
        doneButton.isEnabled = true
    }

    @IBAction func completeSignUp() {
        UserInformation.common.addNewUser(userInformation: TempInformation.common)
        sendNewId()
        TempInformation.common.clearAll()
        dismiss(animated: true, completion: nil)
    }
    
    private func sendNewId() {
        let currentView = self.presentingViewController
        guard let mainView = currentView as? MainViewController else {
            return
        }

        mainView.newId = TempInformation.common.id ?? ""
        print("마지막페이지 \(mainView.newId)")
    }
    
    private func saveTempPhoneNumber() {
        guard let phoneNumberField = phoneNumberTextField,
              let phoneNumber = phoneNumberField.text else {
            return
        }
        TempInformation.common.phoneNumber = phoneNumber
    }

    private func saveTempDateOfBirth() {
        guard let selectDate = datePicker else {
            return
        }
        TempInformation.common.dateOfBirth = selectDate.date
    }

    private func showSavePhoneNumber() {
        guard let phoneNumber = TempInformation.common.phoneNumber else {
            return
        }
        phoneNumberTextField.text = phoneNumber
    }
    
    private func showSaveDateOfBrith() {
        guard let date = TempInformation.common.dateOfBirth else {
            return
        }
        datePicker.date = date
        changeDateLabel(to: date)
    }

    private func setUpDatePicker() {
        datePicker.timeZone = NSTimeZone.local
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(onDidChangeDate(_:)), for: .valueChanged)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func dismissSignUpView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popToPrev() {
        saveTempPhoneNumber()
        saveTempDateOfBirth()
        
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
