//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class ListViewController: UIViewController {
    let tableView = UITableView()
    var productList: [Product] = []
    var isPaging: Bool = false
    var hasPaging: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        productList = OpenMarketData.shared.productList
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        self.tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        configureConstraintToSafeArea(for: tableView)
    }
}

// MARK: - TableView DataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return productList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let product = productList[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell, let price = product.price, let currency = product.currency, let stock = product.stock else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = product.title
            
            if stock == 0 {
                cell.stockLabel.textColor = .orange
                cell.stockLabel.text = "품절"
            } else {
                cell.stockLabel.text = "잔여수량 : \(stock)"
            }
            
            if let salePrice = product.discountedPrice {
                cell.changeConstraint()
                let originalPrice = "\(currency) \(price)"
                let priceLabelText = "\(currency) \(salePrice)"
                let priceBeforeSaleLabelText = NSMutableAttributedString(string: originalPrice)
                let range = priceBeforeSaleLabelText.mutableString.range(of: originalPrice)
                priceBeforeSaleLabelText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
                
                cell.priceBeforeSaleLabel.attributedText = priceBeforeSaleLabelText
                cell.priceLabel.text = priceLabelText
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
                        }
                    }
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            if hasPaging {
                cell.start()
            } else {
                cell.stop()
            }
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false {
                isPaging = true
                loadPage() { result in
                    switch result {
                    case .success(let data):
                        OpenMarketData.shared.productList.append(contentsOf: data.items)
                        if data.items.count == 0 {
                            self.hasPaging = false
                        }
                        self.productList = OpenMarketData.shared.productList
                        self.isPaging = false
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                    
                }
            }
        }
    }
}

