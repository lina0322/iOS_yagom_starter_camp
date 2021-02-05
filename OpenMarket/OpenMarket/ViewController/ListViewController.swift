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
    private var id: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        isPaging = false
        hasPage = true
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
            if let thumbnailURL = productList[indexPath.row].thumbnailURLs?.first {
                OpenMarketData.shared.loadImage(imageURL: thumbnailURL) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            if let index: IndexPath = tableView.indexPath(for: cell) {
                                if index.row == indexPath.row {
                                    cell.thumbnailImageView.image = image
                                }
                            }
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
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

// MARK: - Segue
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        id = OpenMarketData.shared.productList[indexPath.row].id
        performSegue(withIdentifier: OpenMarketString.detailViewIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OpenMarketString.detailViewIdentifier {
            guard let detailViewController = segue.destination as? DetailViewController else {
                return
            }
            detailViewController.id = id
        }
    }
    
    // MARK: - Extension Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height), hasPage, isPaging == false {
            isPaging = true
            loadPage(for: tableView) { result in
                switch result {
                case .success(let hasPage):
                    self.hasPage = hasPage
                    self.isPaging = false
                case .failure(let error):
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
}
