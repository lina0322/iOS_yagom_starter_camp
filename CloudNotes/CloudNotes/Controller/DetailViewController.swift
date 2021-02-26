//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit
import CoreData

final class DetailViewController: UIViewController {
    var note: NSManagedObject? = nil
    var noteTitle: String {
        guard let title = note?.value(forKey: "title") as? String else {
            return String.empty
        }
        return title
    }
    var noteBody: String {
        guard let body = note?.value(forKey: "body") as? String else {
            return String.empty
        }
        return body
    }
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

        let content = NSMutableAttributedString(string: "\(noteTitle) \n\n", attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSMutableAttributedString(string: noteBody, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]))
        detailTextView.attributedText = content
    }
    
    private func configureNavigationItem() {
        let moreDetailButton: UIButton = UIButton()
        moreDetailButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreDetailButton.addTarget(self, action: #selector(touchUpMoreDetailButton), for: .touchUpInside)
        let barButton =  UIBarButtonItem(customView: moreDetailButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func touchUpMoreDetailButton() {
        showActionSheet()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: "Share...", style: .default, handler: { _ in self.showActivityView()})
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in self.showDeleteAlert()})
        let cancleButton = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancleButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView() {
        let shareItem = [noteTitle + "\n" + noteBody]
        let activityViewController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        guard let note = note else {
            print("선택된 데이터가 없다고 알람 보여줘야하는 부분")
            return
        }
        let deleteAlert = UIAlertController(title: "진짜루?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        self.present(deleteAlert, animated: true, completion: nil)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in self.deleteData(note)})
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancleButton)
    }
    
    private func deleteData(_ data: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(data)
    }
}
