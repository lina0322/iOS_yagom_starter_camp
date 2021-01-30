//
//  LaunchViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

final class LaunchViewController: UIViewController {
    let launchImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "launchScreen")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaunchImage()
        setUpdata()
    }

    private func setUpdata() {
        loadPage() { result in
            switch result {
            case .success(let data):
                OpenMarketData.shared.productList.append(contentsOf: data.items)
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
    
    private func configureLaunchImage() {
        let safeArea = view.safeAreaLayoutGuide
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(launchImage)
        
        NSLayoutConstraint.activate([
            launchImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            launchImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            launchImage.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            launchImage.heightAnchor.constraint(equalTo: launchImage.widthAnchor)
        ])
    }
}
