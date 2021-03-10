//
//  NoteTableViewCell.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit
import CoreData

final class NoteTableViewCell: UITableViewCell {
    // MARK: - Property
    
    static var identifier: String {
        return "\(self)"
    }
    
    // MARK: - Outlet
    
    private let titleLabel: UILabel = {
        let label = makeLabel(textStyle: .title1)
        return label
    }()
    private let lastModifiedDateLabel: UILabel = {
        let label = makeLabel()
        return label
    }()
    private let detailLabel: UILabel = {
        let label = makeLabel(textColor: .gray)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        lastModifiedDateLabel.text = nil
        detailLabel.text = nil
    }
    
    func configure(_ note: NSManagedObject) {
        let lastModified = DateFormatter.convertToUserLocaleString(date: note.value(forKey: EntityString.lastModified) as! Date)
        accessoryType = .disclosureIndicator
        titleLabel.text = note.value(forKey: EntityString.title) as? String
        detailLabel.text = note.value(forKey: EntityString.body) as? String
        lastModifiedDateLabel.text = lastModified
    }
    
    // MARK: - UI
    
    static private func makeLabel(textStyle: UIFont.TextStyle = .body, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: textStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
            detailLabel.bottomAnchor.constraint(equalTo: lastModifiedDateLabel.bottomAnchor)
        ])
    }
}
