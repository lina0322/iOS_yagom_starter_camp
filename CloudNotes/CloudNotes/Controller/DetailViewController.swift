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
        
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        detailTextView.addGestureRecognizer(tapTextViewGesture)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isCompactSize: Bool = traitCollection.horizontalSizeClass == .compact
        setToolbarHidden(isCompactSize)
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
    
    @objc func textViewDidTapped(recognizer: UITapGestureRecognizer) {
        guard let textView = recognizer.view as? UITextView else {
            return
        }
        let layoutManager = textView.layoutManager
        var location = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top

        let glyphIndex: Int = textView.layoutManager.glyphIndex(for: location, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: textView.textContainer)
        
        if glyphRect.contains(location) {
            let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
            let attributeName = NSAttributedString.Key.link
            let attributeValue = textView.textStorage.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let url = attributeValue as? URL {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    debugPrint("There is a problem in your link.")
                }
            } else {
                placeCursor(textView, location)
                changeTextViewToNormalState()
            }
        } else {
            changeTextViewToNormalState()
        }
    }
    
    private func placeCursor(_ myTextView: UITextView, _ location: CGPoint) {
        if let tapPosition = myTextView.closestPosition(to: location) {
            let uiTextRange = myTextView.textRange(from: tapPosition, to: tapPosition)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = myTextView.offset(from: myTextView.beginningOfDocument, to: tapPosition)
                let length = myTextView.offset(from: start, to: end)
                myTextView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    private func changeTextViewToNormalState() {
        detailTextView.isEditable = true
        detailTextView.dataDetectorTypes = []
        detailTextView.becomeFirstResponder()
    }
}

