//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

final class NoteTableViewController: UITableViewController {
    private var noteList = [Note]()
    private var noteIndex: Int?
    
    override func viewDidLoad() {
        guard let dataAsset = NSDataAsset(name: NoteString.sample)?.data else {
            debugPrint(ErrorCase.wrongData.localizedDescription)
            return
        }
        decodeData(dataAsset)
        registerCell()
        configureNavigationItem()
    }
    
    private func decodeData(_ data: Data) {
        NoteJSONDecoder.decodeData(data)
        noteList = NoteJSONDecoder.noteList
    }
    
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func configureNavigationItem() {
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddButton))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = NoteString.memo
    }
    
    @objc private func touchUpAddButton() {
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
        guard let noteIndex = noteIndex else {
            showErrorAlert(message: ErrorCase.notSelectedNote.localizedDescription)
            return
        }
        let textToShare = [noteList[noteIndex].title + String.newLine + noteList[noteIndex].body]
        let activityView = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
    }
    
    private func showDeleteAlret() {
        guard let noteIndex = noteIndex else {
            showErrorAlert(message: ErrorCase.notSelectedNote.localizedDescription)
            return
        }
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

// MARK: - DataSource
extension NoteTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            debugPrint(ErrorCase.cellError.localizedDescription)
            return UITableViewCell()
        }
        let note = noteList[indexPath.row]
        cell.configure(note)
        return cell
    }
}

// MARK: - Delegate
extension NoteTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailViewController()
        detailView.noteTitle = noteList[indexPath.row].title
        detailView.noteBody = noteList[indexPath.row].body
        splitViewController?.showDetailViewController(detailView, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        noteIndex = indexPath.row
    }
}
