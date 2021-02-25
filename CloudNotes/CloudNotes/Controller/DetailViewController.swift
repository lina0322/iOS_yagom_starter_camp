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
    var noteIndex: Int? = nil
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
        let isCompactSize: Bool = traitCollection.horizontalSizeClass == .compact

        configureTextView()
        configureNavigationItem()
        setToolbarHidden(isCompactSize)
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
        let moreDetailButton: UIButton = UIButton()
        moreDetailButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreDetailButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        let barButton =  UIBarButtonItem(customView: moreDetailButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func setToolbarHidden(_ hidden: Bool) {
        if hidden {
            return
        }
        let toolbar = UIToolbar()
        let safeArea = view.safeAreaLayoutGuide
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(showActionSheet))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([space, moreButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isTranslucent = true

        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc private func showActionSheet(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: NoteString.share, style: .default, handler: { _ in self.showActivityView(sender)})
        let deleteButton = UIAlertAction(title: NoteString.delete, style: .destructive, handler: { _ in self.showDeleteAlert()})
        let cancleButton = UIAlertAction(title: NoteString.cancel, style: .cancel, handler: nil)
        
        actionSheet.addAction(shareButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancleButton)
        actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView(_ sender: AnyObject) {
        let shareItem = [noteTitle + String.newLine + noteBody]
        let activityViewController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        let deleteAlert = UIAlertController(title: NoteString.deleteTitle, message: NoteString.deleteMessage, preferredStyle: .alert)
        self.present(deleteAlert, animated: true, completion: nil)
        let deleteButton = UIAlertAction(title: NoteString.delete, style: .destructive, handler: nil)
        let cancleButton = UIAlertAction(title: NoteString.cancel, style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancleButton)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isCompactSize: Bool = traitCollection.horizontalSizeClass == .compact
        setToolbarHidden(isCompactSize)
    }
}

