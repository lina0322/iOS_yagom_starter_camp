//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    
    let cancelButton = UIButton()
    var navigationTitle = String.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCancelButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.title = navigationTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func configureCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc func popView() {
       self.navigationController?.popViewController(animated: true)
    }
}
