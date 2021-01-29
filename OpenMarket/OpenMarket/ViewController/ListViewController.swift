//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class ListViewController: UIViewController {
    let tableView = UITableView()
    var productList: ProductList? = nil
    let currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpdata()
        configureTableView()
    }
    
    private func setUpdata() {
        loadPage(number: 1) { result in
            switch result {
            case .success(let data):
                self.productList = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        configureConstraintToSafeArea(for: tableView)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productList = productList else {
            return 0
        }
        return productList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell, let product = productList?.items[indexPath.row], let price = product.price, let currency = product.currency, let stock = product.stock else {
            debugPrint("return default cell")
            return UITableViewCell()
        }
        
        cell.titleLabel.text = product.title
        cell.stockLabel.text = "잔여수량 : \(stock)"
        
        if let salePrice = product.discountedPrice {
            cell.priceBeforeSaleLabel.text = "\(currency) \(price)"
            cell.priceLabel.text = "\(currency) \(salePrice)"
        } else {
            cell.priceLabel.text = "\(currency) \(price)"
        }
        
        DispatchQueue.global().async {
            guard let imageURLText = product.thumbnailURLs?.first, let thumbnailURL = URL(string: imageURLText), let imageData: Data = try? Data(contentsOf: thumbnailURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.thumbnailImageView.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    }
                }
            }
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
