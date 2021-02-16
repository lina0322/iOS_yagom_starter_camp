//
//  NoteTableViewCell.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier: String = "NoteTableViewCell"
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .black
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return titleLabel
    }()
    let lastModifiedDateLabel: UILabel = {
        let lastModifiedDateLabel = UILabel()
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedDateLabel.font = .preferredFont(forTextStyle: .body)
        lastModifiedDateLabel.adjustsFontSizeToFitWidth = true
        lastModifiedDateLabel.adjustsFontForContentSizeCategory = true
        lastModifiedDateLabel.textColor = .black
        lastModifiedDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lastModifiedDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return lastModifiedDateLabel
    }()
    let detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.adjustsFontSizeToFitWidth = false
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.textColor = .gray
        detailLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return detailLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        addSubview(titleLabel)
        addSubview(lastModifiedDateLabel)
        addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            titleLabel.bottomAnchor.constraint(equalTo: lastModifiedDateLabel.topAnchor),
            
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            detailLabel.leadingAnchor.constraint(equalTo: lastModifiedDateLabel.trailingAnchor, constant: 5),
//            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: lastModifiedDateLabel.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        lastModifiedDateLabel.text = nil
        detailLabel.text = nil
    }
}
