//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class OpenMarketViewController: UIViewController {
    private let listViewController = ListViewController()
    private let gridViewController = GridViewController()
    private let registrationButton = UIButton()
    private let segmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }
    
    private func configureView() {
        addChild(listViewController)
        addChild(gridViewController)
        configureConstraintToSafeArea(for: listViewController.view)
        configureConstraintToSafeArea(for: gridViewController.view)
        gridViewController.view.isHidden = true
    }
    
    private func configureNavigationBar() {
        configureRegistrationButton()
        configureSegmentedControl()
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: registrationButton)
    }

    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "LIST", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "GRID", at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    private func configureRegistrationButton() {
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.addTarget(self, action: #selector(touchUpProductRegistrationButton), for: .touchUpInside)
        registrationButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    @objc private func didTapSegmentedControl(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            listViewController.view.isHidden = false
            gridViewController.view.isHidden = true
        }
        else {
            gridViewController.view.isHidden = false
            listViewController.view.isHidden = true
        }
    }
    
    @objc private func touchUpProductRegistrationButton(_ sender: Any) {
        let productRegistrationViewController = ProductRegistrationViewController()
        productRegistrationViewController.modalPresentationStyle = .fullScreen
        present(productRegistrationViewController, animated: true, completion: nil)
    }
}
