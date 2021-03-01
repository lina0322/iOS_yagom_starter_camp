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
    private var noteTitle: String {
        guard let title = note?.value(forKey: EntityString.title) as? String else {
            return String.empty
        }
        return title
    }
    private var noteBody: String {
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
        configureView()
    }
    
    func configureView() {
        configureTextView()
        configureConstraints()
        registerNotificationCenter()
        configureNavigationItem()
        setTapGesture()
        configureKeyboardDoneButton()
    }
    
    // MARK: - UI
    
    private func configureTextView() {
        detailTextView.delegate = self
        
        let content = NSMutableAttributedString(string: noteTitle + String.newLine, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSMutableAttributedString(string: noteBody, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]))
        detailTextView.attributedText = content
    }
    
    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(detailTextView)
        
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(insertDetailViewInset), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetDetailViewInset), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func insertDetailViewInset(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        detailTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc func resetDetailViewInset(_ notification: Notification) {
        detailTextView.contentInset = UIEdgeInsets.zero
    }
    
    private func configureNavigationItem() {        
        let moreButton = UIBarButtonItem(image: UIImage(systemName: NoteString.buttonImage), style: .done, target: self, action: #selector(showActionSheet))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    // MARK: - Tap Gesture
    
    private func setTapGesture() {
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView))
        detailTextView.addGestureRecognizer(tapTextViewGesture)
    }
    
    @objc private func tapTextView(recognizer: UITapGestureRecognizer) {
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
                    showErrorAlert(message: ErrorCase.wrongURL.localizedDescription)
                }
            } else {
                placeCursor(textView, location)
                setTextViewDetective(false)
            }
        } else {
            setTextViewDetective(false)
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
    
    private func setTextViewDetective(_ isDetecvite: Bool) {
        if isDetecvite {
            detailTextView.isEditable = false
        } else {
            detailTextView.isEditable = true
            detailTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Alert
    
    @objc private func showActionSheet(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: NoteString.shareButton, style: .default) { _ in
            self.showActivityView(sender)}
        let deleteButton = UIAlertAction(title: NoteString.deleteButton, style: .destructive) { _
            in self.showDeleteAlert()}
        let cancleButton = UIAlertAction(title: NoteString.cancelButton, style: .cancel, handler: nil)
        
        actionSheet.addAction(shareButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancleButton)
        actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView(_ sender: AnyObject) {
        guard let text = detailTextView.text else {
            debugPrint("text 없음")
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        guard let note = note else {
            showErrorAlert(message: ErrorCase.notSelectedNote.localizedDescription)
            return
        }
        let deleteAlert = UIAlertController(title: NoteString.deleteTitle, message: NoteString.deleteMessage, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: NoteString.deleteButton, style: .destructive) { _ in
            DataModel.shared.deleteData(note)
        }
        let cancleButton = UIAlertAction(title: NoteString.cancelButton, style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancleButton)
        present(deleteAlert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: NoteString.confirmButton, style: .default, handler: nil)
        alert.addAction(confirmButton)
        present(alert, animated: true, completion: nil)
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
    
    @objc private func touchUpDoneButton(_ sender: UIButton) {
        view.endEditing(true)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let note = note else {
            return
        }
        if detailTextView.text == String.empty {
            DataModel.shared.deleteData(note)
        }
        DataModel.shared.editData(detailTextView.text, editInto: note)
        setTextViewDetective(true)
        NotificationCenter.default.post(name: NSNotification.Name(NoteString.notification), object: nil)
    }
}
