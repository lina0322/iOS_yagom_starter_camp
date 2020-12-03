//
//  SignUpDetailViewController.swift
//  SignUpFlow
//
//  Created by sole on 2020/12/02.
//

import UIKit

class SignUpDetailViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(onDidChangeDate(_:)), for: .valueChanged)
    }
    
    @objc func onDidChangeDate(_ sender: UIDatePicker) {
        let date = sender.date
        let format = DateFormatter()
        
        format.dateFormat = "MMMM d, yyyy"
        dateLabel.text = format.string(from: date)
    }
    
    @objc func pickDate() {
        
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
