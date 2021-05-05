//
//  ThingTableHeaderView.swift
//  ProjectManager
//
//  Created by 임성민 on 2021/03/10.
//

import UIKit

final class ThingTableHeaderView: UIView {
    
    // MARK: - Property
    
    private let countLabelDiameter: CGFloat = 25
    
    // MARK: - Outlet
    
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    
    // MARK: - Init
    
    init(height: Int, title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        titleLabel.text = title
        configureConstraints()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
        setStyle()
    }
    
    // MARK: - UI
    
    private func configureConstraints() {
        addSubview(titleLabel)
        addSubview(countLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            countLabel.widthAnchor.constraint(equalToConstant: countLabelDiameter),
            countLabel.heightAnchor.constraint(equalToConstant: countLabelDiameter),
            countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5)
        ])
    }
    
    private func setStyle() {
        backgroundColor = .systemGray5
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        countLabel.font = .systemFont(ofSize: 15)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .black
        countLabel.layer.cornerRadius = countLabelDiameter/2
        countLabel.layer.masksToBounds = true
    }
    
    func setCount(_ count: Int) {
        countLabel.text = String(count)
    }
}
