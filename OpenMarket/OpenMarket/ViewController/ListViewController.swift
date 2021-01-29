//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

class ListViewController: UIViewController {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            print("return default cell")
            return UITableViewCell()
        }
        cell.thumbnailImageView.backgroundColor = .red
        cell.titleLabel.text = "isEnable????"
        cell.stockLabel.text = "stock is 10"
        cell.discountedPriceLabel.text = "usd 100000"
        cell.priceLabel.text = "usd 10000000"
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
