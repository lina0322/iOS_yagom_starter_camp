//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

class ListViewController: UIViewController {
    let tableView = UITableView()
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        loadProduct(158)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            print("return default cell")
            return UITableViewCell()
        }
//        cell.thumbnailImageView.backgroundColor = .red
//        cell.titleLabel.text = "isEnable????"
//        cell.stockLabel.text = "stock is 10"
//        cell.discountedPriceLabel.text = "usd 100000"
//        cell.priceLabel.text = "usd 10000000"
//"https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"
//        cell.thumbnailImageView.image = nil
        
        DispatchQueue.global().async {
            guard let thumbnailURL = URL(string: "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png") else {
                return
            }
            //Data(contentsOf) << 동기메서드
            guard let imageData: Data = try? Data(contentsOf: thumbnailURL) else {
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
        cell.titleLabel.text = product?.title
        cell.stockLabel.text = "\(String(describing: product?.stock))"
        cell.discountedPriceLabel.text = "\(product?.discountedPrice)"
        cell.priceLabel.text = "\(product?.price!)"
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController {
    func loadProduct(_ id: UInt) -> Product? {
        OpenMarketJSONDecoder<Product>.decodeData(about: .loadProduct(id: id)) { result in
            switch result {
            case .success(let data):
                self.product = data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
        return product
    }
}
