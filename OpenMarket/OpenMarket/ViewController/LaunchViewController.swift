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
        let page = OpenMarketData.shared.tableViewCurrentPage
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: page), networkHandler: NetworkHandler(session: MockURLSession(apiRequestType: .loadPage(page: 1)))) { result in
            switch result {
            case .success(let data):
                OpenMarketData.shared.tableViewProductList.append(contentsOf: data.items)
                OpenMarketData.shared.tableViewCurrentPage += 1
                OpenMarketData.shared.collectionViewProductList.append(contentsOf: data.items)
                OpenMarketData.shared.collectionViewCurrentPage += 1
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.goOpenMarketView()
            }
        }
    }
    
    private func goOpenMarketView() {
        if let openMarketViewController = storyboard?.instantiateViewController(identifier: "OpenMarketNavigation") {
            openMarketViewController.modalPresentationStyle = .overFullScreen
            present(openMarketViewController, animated: false, completion: nil)
        }
    }
}
