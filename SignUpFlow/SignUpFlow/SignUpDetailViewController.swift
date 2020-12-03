//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//  Todo: 전화번호 사이에 - 넣어주기

import UIKit

class SignUpDetailViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        changeDateLabel(to: datePicker.date)
        datePicker.addTarget(self, action: #selector(onDidChangeDate(_:)), for: .valueChanged)
    }
    
    @objc func onDidChangeDate(_ sender: UIDatePicker) {
        let date = sender.date
        changeDateLabel(to: date)
    }
    
    func changeDateLabel(to date: Date) {
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
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
