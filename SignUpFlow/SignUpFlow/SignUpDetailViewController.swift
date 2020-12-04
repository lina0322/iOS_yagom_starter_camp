//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//  Todo: 전화번호 사이에 - 넣어주기, 전화번호 길이 확인, 자기소개랑 전화번호에 done키 같은거 만들어주기, 마지막 페이지 정보저장, 마지막페이지에서 첫번째 페이지로 아이디 넘겨주기

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
        
        showSaveInformation()
        
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
        saveTempData()
        UserInformation.common.addNewUser(userInformation: TempInformation.common)
        sendNewId()
        TempInformation.common.clearAll()
        dismiss(animated: true, completion: nil)
    }
    
    func sendNewId() {
        guard let currentStoryboard = self.storyboard else {
            return
        }
        
        guard let mainView = currentStoryboard.instantiateViewController(withIdentifier: "MainView") as? MainViewController else {
            return
        }
        mainView.newId = TempInformation.common.id ?? ""
        print("마지막페이지 \(mainView.newId)")
    }
    
    func saveTempData() {
        TempInformation.common.phoneNumber = phoneNumberTextField.text
        TempInformation.common.dateOfBirth = datePicker.date
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
