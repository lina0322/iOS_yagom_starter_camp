//
//  NoteTableViewCell.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    let lastModifiedDateLabel: UILabel = {
        let lastModifiedDateLabel = UILabel()
        lastModifiedDateLabel.adjustsFontForContentSizeCategory = true
        lastModifiedDateLabel.font = .preferredFont(forTextStyle: .body)
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return lastModifiedDateLabel
    }()
    let detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = .gray
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return detailLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lastModifiedDateLabel)
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            lastModifiedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            detailLabel.leadingAnchor.constraint(equalTo: lastModifiedDateLabel.trailingAnchor, constant: 40),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailLabel.centerYAnchor.constraint(equalTo: lastModifiedDateLabel.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        lastModifiedDateLabel.text = nil
        detailLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
