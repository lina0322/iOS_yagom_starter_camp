//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

class NoteTableViewController: UIViewController {
    let tableView = UITableView()
    var noteList = [Note]()
    let dateFormatter = DateFormat()
    
    override func viewDidLoad() {
        var decoder: NoteJSONDecoder = NoteJSONDecoder()
        decoder.decodeData()
        noteList = decoder.notes
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        self.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}


extension NoteTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = noteList[indexPath.row]
        let title = note.title
        let body = note.body
        let lastModifiedDate = note.lastModified
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            debugPrint("CellError")
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        
        cell.titleLabel.text = title
        cell.detailLabel.text = body
        cell.lastModifiedDateLabel.text = dateFormatter.convertFormat(unixTimeStamp: lastModifiedDate)
        
        return cell
    }
    
}
