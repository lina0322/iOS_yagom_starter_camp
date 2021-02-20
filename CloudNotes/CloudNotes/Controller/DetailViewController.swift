//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/19.
//

import UIKit

final class DetailViewController: UIViewController {
    var noteTitle: String = String.empty
    var body: String = String.empty
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
        configureConstraints()
        detailTextView.text = "\(noteTitle)\n\n\(body)"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        navigationController?.navigationBar.isHidden = false

        if traitCollection.verticalSizeClass == .compact {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(detailTextView)
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
