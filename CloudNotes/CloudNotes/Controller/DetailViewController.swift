//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit

final class DetailViewController: UIViewController {
    var noteTitle: String = String.empty
    var noteBody: String = String.empty
    private let detailTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    private func configureTextView() {
        view.addSubview(detailTextView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
               
        let content = NSMutableAttributedString(string: "\(noteTitle) \n\n", attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSMutableAttributedString(string: noteBody, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]))
        detailTextView.attributedText = content
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .compact {
            navigationController?.navigationBar.isHidden = true
        } else {
            navigationController?.navigationBar.isHidden = false
        }
    }
}

