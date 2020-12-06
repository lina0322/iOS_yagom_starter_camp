//
//  SignInViewController.swift
//  SignUpFlow
//
//  Created by 임리나 on 2020/12/04.
//

import UIKit

class SignInViewController: UIViewController {

    @IBAction func touchUpBackButton() {
        popToPreviousPage()
    }
}

extension UIViewController {
    func popToPreviousPage() {
        guard let currentView = self.navigationController else {
            return
        }
        currentView.popViewController(animated: true)
    }
}
