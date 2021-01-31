//
//  LaunchViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaunchImage()
        setUpData()
    }
    
    private func configureLaunchImage() {
        let launchImage = UIImageView()
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
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: page)) { result in
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
