//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UITableViewController {
    private var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = NSDataAsset(name: NoteString.sample)?.data else {
            debugPrint(NoteError.wrongData.localizedDescription)
            return
        }
        
        decodeData(data)
        registerCell()
        configureNavigationBar()
    }
    
    private func decodeData(_ data: Data) {
        guard let noteData = NoteJSONDecoder.decodeData(data) else {
            debugPrint(NoteError.wrongData.localizedDescription)
            return
        }
        notes.append(contentsOf: noteData)
    }
    
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationItem.title = NoteString.memo
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }
    
    @objc private func addNote() {
        
    }
}


// MARK: - DataSource
extension NoteViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.dateLabel.text = note.lastModifiedDate
        cell.detailLabel.text = note.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - Delegate
extension NoteViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.noteTitle = notes[indexPath.row].title
        detailViewController.body = notes[indexPath.row].body
        splitViewController?.showDetailViewController(detailViewController, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
