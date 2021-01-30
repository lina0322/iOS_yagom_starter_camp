//
//  GridViewController.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class GridViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    private func configureCollectionView() {
        configureConstraintToSafeArea(for: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let width: CGFloat = (collectionView.frame.width - itemSpacing) / 2
        let height: CGFloat = collectionView.frame.height / 2.5
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - CollectionView DataSource
extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        // default value for simulating
        cell.backgroundColor = .orange
        cell.titleImageView.backgroundColor = .green
        cell.titleLabel.text = "레이아웃 잘 잡혔나"
        cell.priceBeforeSaleLabel.text = "할인전 가격 취소선 들어가야해요"
        cell.priceLabel.text = "판매되는 가격"
        cell.stockLabel.text = "재고 없으면 품절로 바꾸기!"
        return cell
    }
}

// MARK: - CollectionView Delegate
extension GridViewController: UICollectionViewDelegate {
    
}
