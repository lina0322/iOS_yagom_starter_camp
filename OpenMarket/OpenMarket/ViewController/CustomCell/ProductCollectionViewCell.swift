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
    private let spacingView1 = UIView()
    private let spacingView2 = UIView()
    lazy private var labelsStackView: UIStackView = {
        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, spacingView1, priceBeforeSaleLabel, priceLabel, spacingView2, stockLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 3
        labelsStackView.distribution = .fillEqually
        labelsStackView.alignment = .center
        return labelsStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellBorder()
        configureUI()
        configureConstraints()
    }
    
    func fillLabels(about product: Product) {
        guard let title = product.title, let price = product.price, let stock = product.stock, let currency = product.currency else {
            return
        }
        titleLabel.text = title
        stockLabel.text = "잔여수량 : \(stock.addComma())"
        priceLabel.text = "\(currency) \(price.addComma())"
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        }
        if let salePrice = product.discountedPrice {
            let originalPrice = "\(currency) \(price.addComma())"
            let priceLabelText = "\(currency) \(salePrice.addComma())"
            let priceBeforeSaleLabelText = NSMutableAttributedString(string: originalPrice)
            let range = priceBeforeSaleLabelText.mutableString.range(of: originalPrice)
            priceBeforeSaleLabelText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            priceBeforeSaleLabel.attributedText = priceBeforeSaleLabelText
            priceLabel.text = priceLabelText
        } else {
            removePriceBeforeSaleLabel()
        }
    }
    
    private func configureCellBorder() {
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func configureUI() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        priceBeforeSaleLabel.translatesAutoresizingMaskIntoConstraints = false
        spacingView1.translatesAutoresizingMaskIntoConstraints = false
        spacingView2.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
        priceBeforeSaleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        priceLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.font = .preferredFont(forTextStyle: .body)
        priceBeforeSaleLabel.font = .preferredFont(forTextStyle: .body)

        
        titleLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        priceBeforeSaleLabel.textAlignment = .center
        
        priceLabel.textColor = .gray
        stockLabel.textColor = .gray
        priceBeforeSaleLabel.textColor = .red
    }
    
    private func configureConstraints() {
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            spacingView1.heightAnchor.constraint(greaterThanOrEqualToConstant: 5),
            spacingView2.heightAnchor.constraint(equalTo: spacingView1.heightAnchor),
            
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
        priceLabel.text = String.empty
        stockLabel.text = String.empty
        stockLabel.textColor = .gray
        priceBeforeSaleLabel.text = String.empty
        priceBeforeSaleLabel.attributedText = NSMutableAttributedString(string: String.empty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
