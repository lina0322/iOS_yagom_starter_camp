//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit

class NoteViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    var noteList = [Note]()
    let dateFormatter = DateFormat()
    lazy var addNoteButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        var decoder: NoteJSONDecoder = NoteJSONDecoder()
        decoder.decodeData()
        noteList = decoder.notes
        view.backgroundColor = .white
        setUpTableView()
        setUpNavigationItem()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        self.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.rightBarButtonItem = addNoteButton
        self.navigationItem.title = "메뉴"
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}

extension NoteViewController: UITableViewDataSource {
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
