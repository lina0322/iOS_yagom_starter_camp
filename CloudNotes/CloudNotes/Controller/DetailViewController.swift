//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit
import CoreData

final class DetailViewController: UIViewController {
    // MARK: - Property
    var note: NSManagedObject? = nil
    var noteTitle: String {
        guard let title = note?.value(forKey: EntityString.title) as? String else {
            return String.empty
        }
        return title
    }
    var noteBody: String {
        guard let body = note?.value(forKey: EntityString.body) as? String else {
            return String.empty
        }
        return body
    }

    // MARK: - Outlet
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let isCompactSize: Bool = traitCollection.horizontalSizeClass == .compact

        configureTextView()
        configureNavigationItem()
        setToolbarHidden(isCompactSize)
        setTapGesture()
        configureKeyboardDoneButton()
    }

    // MARK: UI
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
        moreDetailButton.setImage(UIImage(systemName: NoteString.buttonImage), for: .normal)
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
        let moreButton = UIBarButtonItem(image: UIImage(systemName: NoteString.buttonImage), style: .done, target: self, action: #selector(showActionSheet))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([space, moreButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false

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
    
    // MARK: - Tap Gesture
    private func setTapGesture() {
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        detailTextView.addGestureRecognizer(tapTextViewGesture)
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
    
    // MARK: - Keyboard
    private func configureKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton))
        
        toolBarKeyboard.items = [space, doneButton]
        detailTextView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    // MARK: Alert
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
        guard let note = note else {
            print("선택된 데이터가 없다고 알람 보여줘야하는 부분")
            return
        }
        let deleteAlert = UIAlertController(title: NoteString.deleteTitle, message: NoteString.deleteMessage, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: NoteString.delete, style: .destructive) { _ in
            DataModel.shared.deleteData(note)
            
        }
        let cancleButton = UIAlertAction(title: NoteString.cancel, style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancleButton)
        present(deleteAlert, animated: true, completion: nil)
    }
}
