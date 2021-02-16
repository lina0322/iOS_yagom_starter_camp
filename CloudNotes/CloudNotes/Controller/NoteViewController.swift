//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {
    private let tableView = UITableView()
    private var notes: [Note] = []
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let locale = Locale.autoupdatingCurrent.identifier
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = NSDataAsset(name: NoteString.sample)?.data else {
            debugPrint(NoteError.wrongData.localizedDescription)
            return
        }
        
        decodeData(data)
        setTableView()
        configureNavigationBar()
    }
    
    func decodeData(_ data: Data) {
        guard let noteData = NoteJSONDecoder.decodeData(data) else {
            debugPrint(NoteError.wrongData.localizedDescription)
            return
        }
        notes.append(contentsOf: noteData)
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .white
        navigationItem.title = NoteString.memo
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }
    
    @objc func addNote() {
        
    }
}

extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            debugPrint("hi")
            return UITableViewCell()
        }
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.dateLabel.text = dateFormatter.string(from: note.lastModifiedDate)
        cell.detailLabel.text = note.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
