//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class OpenMarketViewController: UIViewController {
    private var listViewController = ListViewController()
    private var gridViewController = GridViewController()
    private let segmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }
    
    private func configureView() {
        guard let listView = storyboard?.instantiateViewController(identifier: ViewIdentifier.list) as? ListViewController, let gridView = storyboard?.instantiateViewController(identifier: ViewIdentifier.grid) as? GridViewController else {
            return
        }
        listViewController = listView
        gridViewController = gridView
        addChild(listViewController)
        addChild(gridViewController)
        configureConstraintToSafeArea(for: listViewController.view)
        configureConstraintToSafeArea(for: gridViewController.view)
        gridViewController.view.isHidden = true
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.titleView = segmentedControl
        configureSegmentedControl()
    }
    
    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: UIString.list, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: UIString.grid, at: 1, animated: true)
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
        if segue.identifier == ViewIdentifier.registration {
            guard let registrationViewController = segue.destination as? ProductRegistrationViewController else {
                return
            }
            registrationViewController.title = UIString.productRegistration
        }
    }
}
