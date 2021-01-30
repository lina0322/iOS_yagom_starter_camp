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
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    let label: UILabel = {
       let label = UILabel()
        label.text = "마지막 페이지입니다:)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func start() {
        addSubview(activityIndicatorView)
        
        let safeArea = self.safeAreaLayoutGuide
        activityIndicatorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
    
    func stop() {
        addSubview(label)
        
        let safeArea = self.safeAreaLayoutGuide
        label.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
