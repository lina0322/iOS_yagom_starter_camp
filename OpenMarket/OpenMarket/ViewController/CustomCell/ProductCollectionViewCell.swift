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
    lazy var labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, priceBeforeSaleLabel, priceLabel, stockLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 10
        labelsStackView.distribution = .fillEqually
        labelsStackView.alignment = .center
        return labelsStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.systemGray4.cgColor
        configureUI()
        configureConstraints()
    }
    
    private func configureUI() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
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
        self.contentView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 5),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
        
    func removePriceBeforeSaleLabel() {
        priceBeforeSaleLabel.removeFromSuperview()
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
