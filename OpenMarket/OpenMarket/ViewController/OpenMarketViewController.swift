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
        configureSegmentedControl()
        navigationItem.titleView = segmentedControl
    }

    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: OpenMarketString.list, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: OpenMarketString.grid, at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OpenMarketString.registrationViewIdentifier {
            guard let registrationViewController = segue.destination as? ProductRegistrationViewController else {
                return
            }
            registrationViewController.navigationTitle = OpenMarketString.productRegistration
        }
    }
}
