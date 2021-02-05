//
//  LaunchViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

final class LaunchViewController: UIViewController {
    private let indicator = UIActivityIndicatorView()
    private let launchImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureLaunchImage()
        configureIndicatorConstraint()
        indicator.startAnimating()
        setUpData()
    }
    
    private func configureIndicatorConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: launchImage.bottomAnchor)
        ])
    }
    
    private func configureLaunchImage() {
        let safeArea = view.safeAreaLayoutGuide
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        launchImage.image = UIImage(named: "launchScreen")
        launchImage.contentMode = .scaleAspectFit
        view.addSubview(launchImage)
        
        NSLayoutConstraint.activate([
            launchImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            launchImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            launchImage.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            launchImage.heightAnchor.constraint(equalTo: launchImage.widthAnchor)
        ])
    }
    
    private func setUpData() {
        loadPage(for: nil) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.goOpenMarketView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
    
    private func goOpenMarketView() {
        guard let openMarketViewController = storyboard?.instantiateViewController(identifier: OpenMarketString.openMarektControllerIdentifier) else {
            return
        }
        navigationController?.pushViewController(openMarketViewController, animated: true)
    }
}
