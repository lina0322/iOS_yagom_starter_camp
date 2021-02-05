//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/02/05.
//

import UIKit

final class DetailViewController: UIViewController, Insertable {
    var id: Int? = nil
    var product: Product? = nil
    private let idLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        setUpProductData()
    }
    
    func test() {
        let safeArea = view.safeAreaLayoutGuide
        guard let description = product?.descriptions else { return }
        view.backgroundColor = .white
        view.addSubview(idLabel)
        idLabel.text = "\(description)"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.numberOfLines = 0
        idLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        idLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        idLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
    }
    
    private func configureNavigationbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActionSheet))
        
    }
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editingButton = UIAlertAction(title: OpenMarketString.editing, style: .default, handler: nil)
        let deletionButton = UIAlertAction(title: OpenMarketString.deletion, style: .destructive) { _ in
            DispatchQueue.main.async {
                self.shwoDeletionAlert()
            }
        }
        let cancelButton = UIAlertAction(title: OpenMarketString.cancel, style: .cancel, handler: nil)
        
        actionSheet.addAction(editingButton)
        actionSheet.addAction(deletionButton)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func shwoDeletionAlert() {
        let alert = UIAlertController(title: OpenMarketString.deletion, message: OpenMarketString.deletionMessage, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: OpenMarketString.confirm, style: .default) { _ in
            self.deleteProduct(password: alert.textFields?.first?.text)
        }
        let cancelButton = UIAlertAction(title: OpenMarketString.cancel, style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpProductData() {
        guard let id = id else {
            return
        }
        OpenMarketJSONDecoder<Product>.decodeData(about: .loadProduct(id: id)) { result in
            switch result {
            case .success(let data):
                self.product = data
                DispatchQueue.main.async {
                    self.test()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
    
    private func deleteProduct(password: String?) {
        guard let id = product?.id, let password = password else {
            return
        }
        let item = Product(forDeletePassword: password, id: id)
        Uploader.deleteData(product: item, apiRequestType: .deleteProduct(id: id)) { result in 
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.resetData()
                    self.showSuccessAlert(about: "삭제 성공")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
    
    func resetData() {
        OpenMarketData.shared.productList.removeAll()
        OpenMarketData.shared.currentPage = 1
        self.loadNextPage(for: nil) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showSuccessAlert(about: OpenMarketString.registrationSuccess)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(about: error.localizedDescription)
                }
            }
        }
    }
}
