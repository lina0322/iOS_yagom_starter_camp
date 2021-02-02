//
//  ProductTableViewCell.swift
//  OpenMarket
//
//  Created by Jinho Choi on 2021/01/29.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let stockLabel = UILabel()
    let priceBeforeSaleLabel = UILabel()
    private let spacingView = UIView()
    private var priceLabelLeadingAnchorConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
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
        if let discountedPrice = product.discountedPrice {
            changeConstraint()
            let currentPrice = "\(currency) \(discountedPrice.addComma())"
            let originalPrice = "\(currency) \(price.addComma())"
            let priceBeforeSaleLabelText = NSMutableAttributedString(string: originalPrice)
            let range = priceBeforeSaleLabelText.mutableString.range(of: originalPrice)
            priceBeforeSaleLabelText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            priceBeforeSaleLabel.attributedText = priceBeforeSaleLabelText
            priceLabel.text = currentPrice
        }
    }
    
    private func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        priceBeforeSaleLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
        priceBeforeSaleLabel.adjustsFontSizeToFitWidth = true

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        priceLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.font = .preferredFont(forTextStyle: .body)
        priceBeforeSaleLabel.font = .preferredFont(forTextStyle: .body)
        
        stockLabel.textAlignment = .right
        
        priceLabel.textColor = .gray
        stockLabel.textColor = .gray
        priceBeforeSaleLabel.textColor = .red
    }
    
    private func configureConstraints() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(stockLabel)
        self.contentView.addSubview(priceBeforeSaleLabel)
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(spacingView)

        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.17),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.3),
            
            spacingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            spacingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            spacingView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            spacingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 5),
            
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
       
            priceBeforeSaleLabel.topAnchor.constraint(equalTo: spacingView.bottomAnchor, constant: 5),
            priceBeforeSaleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            priceBeforeSaleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
       
            priceLabel.topAnchor.constraint(equalTo: priceBeforeSaleLabel.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: priceBeforeSaleLabel.bottomAnchor)
        ])
        
        priceLabelLeadingAnchorConstraint = priceLabel.leadingAnchor.constraint(equalTo: priceBeforeSaleLabel.trailingAnchor, constant: 0)
        priceLabelLeadingAnchorConstraint.isActive = true
        
        stockLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        stockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func changeConstraint() {
        priceLabelLeadingAnchorConstraint.isActive = false
        priceLabelLeadingAnchorConstraint = priceLabel.leadingAnchor.constraint(equalTo: priceBeforeSaleLabel.trailingAnchor, constant: 10)
        priceLabelLeadingAnchorConstraint.isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = String.empty
        priceLabel.text = String.empty
        priceBeforeSaleLabel.text = String.empty
        stockLabel.text = String.empty
        stockLabel.textColor = .gray
        priceBeforeSaleLabel.attributedText = NSMutableAttributedString(string: String.empty)
        priceLabelLeadingAnchorConstraint.isActive = false
        priceLabelLeadingAnchorConstraint = priceLabel.leadingAnchor.constraint(equalTo: priceBeforeSaleLabel.trailingAnchor, constant: 0)
        priceLabelLeadingAnchorConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
