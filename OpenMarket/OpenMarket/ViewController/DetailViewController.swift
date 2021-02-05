//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/02/05.
//

import UIKit

final class DetailViewController: UIViewController {
    var id: Int? = nil
    let idLabel = UILabel()
    private let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
        configureNavigationbar()
    }
    
    func test() {
        let safeArea = view.safeAreaLayoutGuide
        guard let id = id else { return }
        view.backgroundColor = .white
        idLabel.text = "\(id)"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLabel)
        idLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        idLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100).isActive = true
    }
    
    func configureNavigationbar() {
        configureCancelButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func configureCancelButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
