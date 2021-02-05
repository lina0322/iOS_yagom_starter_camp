//
//  GridViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class GridViewController: UIViewController {
    private var isPaging: Bool = false
    private var hasPage: Bool = true
    private var scrollFlag = false
    private let itemSpacing: CGFloat = 8
    private var id: Int? = nil
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        isPaging = false
        hasPage = true
    }
    
    private func configureCollectionView() {
        configureConstraintToSafeArea(for: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width: CGFloat = (collectionView.frame.width - itemSpacing * 4) / 2
            let height: CGFloat = width * 1.5
            return CGSize(width: width, height: height)
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

// MARK: - CollectionView DataSource
extension GridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return OpenMarketData.shared.productList.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let productList = OpenMarketData.shared.productList
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.fillLabels(about: productList[indexPath.row])
            if let thumbnailURL = productList[indexPath.row].thumbnailURLs?.first {
                OpenMarketData.shared.loadImage(imageURL: thumbnailURL) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            cell.thumbnailImageView.image = image
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as? LoadingCollectionViewCell else {
                return UICollectionViewCell()
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
extension GridViewController: UICollectionViewDelegate, Insertable {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            loadNextPage(for: collectionView) { result in
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
