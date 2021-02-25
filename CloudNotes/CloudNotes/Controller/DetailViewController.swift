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
        configureNavigationItem()
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
        
        let content = NSMutableAttributedString(string: noteTitle + String.newLine + String.newLine, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSMutableAttributedString(string: noteBody, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]))
        detailTextView.attributedText = content
    }
    
    private func configureNavigationItem() {
        
    }
    
    private func touchUpMoreButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: NoteString.share, style: .default) { _ in
            self.showActivityView()
        }
        let deleteButton = UIAlertAction(title: NoteString.delete, style: .destructive) { _ in
            self.showDeleteAlret()
        }
        let cancelButton = UIAlertAction(title: NoteString.cancel, style: .cancel, handler: nil)
        
        actionSheet.addAction(shareButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView() {
        let textToShare = [noteTitle + String.newLine + noteBody]
        let activityView = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
    }
    
    private func showDeleteAlret() {
        let alert = UIAlertController(title: NoteString.deleteTitle, message: NoteString.deleteMessage, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: NoteString.cancel, style: .default, handler: nil)
        let deleteButton = UIAlertAction(title: NoteString.delete, style: .destructive) { _ in
            // deleteData(noteIndex)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(title: String? = nil, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: NoteString.confirm, style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

