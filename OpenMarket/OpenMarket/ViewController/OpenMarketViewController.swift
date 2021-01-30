//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class OpenMarketViewController: UIViewController {
    let listViewController = ListViewController()
    let gridViewController = GridViewController()
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "LIST", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "GRID", at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    let productRegistrationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSegmentedControl()
        configureNavigationBar()
        setButton()
        productRegistrationButton.addTarget(self, action: #selector(touchUpProductRegistrationButton), for: .touchUpInside)
    }
    
    private func configureView() {
        addChild(listViewController)
        addChild(gridViewController)
        
        configureConstraintToSafeArea(for: listViewController.view)
        configureConstraintToSafeArea(for: gridViewController.view)
        gridViewController.view.isHidden = true
    }
    
    private func configureSegmentedControl() {
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
    
    private func configureNavigationBar() {
        self.navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: productRegistrationButton)
    }
    
    func setButton() {
        productRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
//        productRegistrationButton.imageView?.image = UIImage(systemName: "house")
        productRegistrationButton.contentMode = .scaleAspectFit
        productRegistrationButton.backgroundColor = .red
        NSLayoutConstraint.activate([
            productRegistrationButton.widthAnchor.constraint(equalToConstant: 30),
            productRegistrationButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func touchUpProductRegistrationButton(_ sender: Any) {
        let productRegistrationViewController = ProductRegistrationViewController()
        productRegistrationViewController.modalPresentationStyle = .fullScreen
        self.present(productRegistrationViewController, animated: true, completion: nil)
    }
}

// MARK: - Extension
extension UIViewController {
    func configureConstraintToSafeArea(for object: UIView) {
        object.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(object)
        
        NSLayoutConstraint.activate([
            object.topAnchor.constraint(equalTo: safeArea.topAnchor),
            object.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            object.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            object.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func loadPage(completionHandler: @escaping ((Result<ProductList, OpenMarketError>) -> ())) {
        let page = OpenMarketData.shared.currentPage
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: page)) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
                OpenMarketData.shared.currentPage += 1
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
