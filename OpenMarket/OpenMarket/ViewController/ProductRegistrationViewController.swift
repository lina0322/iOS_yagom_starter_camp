//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCancelButton()
    }
    
    private func configureCancelButton() {
        let cancelButton = UIButton()
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(cancelButton)
        cancelButton.setTitle("close", for: .normal)
        cancelButton.backgroundColor = .blue
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelRegistration), for: .touchUpInside)
    }

    @objc private func cancelRegistration() {
        self.dismiss(animated: true, completion: nil)
    }
}
