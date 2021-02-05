//
//  LoadingTableViewCell.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    let indicator = UIActivityIndicatorView()
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func startIndicator() {
        let safeArea = self.safeAreaLayoutGuide
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    }
    
    func showLabel() {
        let safeArea = self.safeAreaLayoutGuide
        label.text = OpenMarketString.lastPage
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        indicator.stopAnimating()
        label.text = String.empty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
