//
//  ProductCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/30.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let stockLabel = UILabel()
    let priceBeforeSaleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }
    
    private func configureUI() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceBeforeSaleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.adjustsFontSizeToFitWidth = true
        priceBeforeSaleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        priceBeforeSaleLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.font = .preferredFont(forTextStyle: .body)
        
        titleLabel.textAlignment = .center
        priceBeforeSaleLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        
        priceBeforeSaleLabel.textColor = .red
        priceLabel.textColor = .gray
        stockLabel.textColor = .gray
    }
    
    private func configureConstraints() {
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceBeforeSaleLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            priceBeforeSaleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceBeforeSaleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceBeforeSaleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            priceBeforeSaleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: priceBeforeSaleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stockLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        titleLabel.text = String.empty
        priceBeforeSaleLabel.text = String.empty
        priceBeforeSaleLabel.attributedText = NSMutableAttributedString(string: String.empty)
        priceLabel.text = String.empty
        stockLabel.text = String.empty
        stockLabel.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
