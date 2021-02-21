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
        print("button pressed")
        showActionSheet()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: "Share...", style: .default, handler: { _ in self.showActivityView()})
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancleButton = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancleButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showActivityView() {
        guard let noteIndex = noteIndex else {
            print("선택된 노트가 없음")
            return
        }
        let shareItem = [noteList[noteIndex].title + "\n" + noteList[noteIndex].body]
        let activityViewController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
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

// MARK: - UIAlertController

