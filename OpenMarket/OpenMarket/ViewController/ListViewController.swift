//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class ListViewController: UIViewController {
    private let tableView = UITableView()
    private var isPaging: Bool = false
    private var hasPage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        configureConstraintToSafeArea(for: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
    }
}

// MARK: - TableView DataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return OpenMarketData.shared.productList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let productList = OpenMarketData.shared.productList
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
                return UITableViewCell()
            }
            cell.fillLabels(about: productList[indexPath.row])
            DispatchQueue.global().async {
                guard let imageURLText = productList[indexPath.row].thumbnailURLs?.first, let thumbnailURL = URL(string: imageURLText), let imageData: Data = try? Data(contentsOf: thumbnailURL) else {
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
            if hasPage {
                cell.startIndicator()
            } else {
                cell.showLabel()
            }
            return cell
        }
    }
}

// MARK: - Extension Scroll
extension ListViewController: UITableViewDelegate, Insertable {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        if offsetY > (contentHeight - height), hasPage {
            if isPaging == false {
                isPaging = true
                loadNextPage(for: tableView) { result in
                    switch result {
                    case .success(let hasPage):
                        self.hasPage = hasPage
                        self.isPaging = false
                    case .failure(let error):
                        self.showAlert(about: error.localizedDescription)
                    }
                }
            }
        }
    }
}
