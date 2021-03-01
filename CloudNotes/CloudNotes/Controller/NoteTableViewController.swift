//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit
import CoreData

final class NoteTableViewController: UITableViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        registerCell()
        setUpNotificationCenter()
        configureNavigationItem()
        configureDetailView()
        DataModel.shared.fetchData()
    }
    
    // MARK: - UI
    
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(NoteString.notification), object: nil)
    }
    
    @objc private func reloadTableView(_ notification:Notification) {
        tableView.reloadData()
        configureDetailView()
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddButton))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = NoteString.memo
    }
    
    @objc private func touchUpAddButton() {
        DataModel.shared.saveData(NoteString.newNoteMessage)
        showDetailView()
        tableView.reloadData()
    }
    
    private func configureDetailView() {
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let isRegular: Bool = traitCollection.horizontalSizeClass == .regular
        if isPad || isRegular {
            showDetailView()
        }
    }
    
    private func showDetailView(about note: NSManagedObject? = nil) {
        let detailView = DetailViewController()
        if let note = note {
            detailView.note = note
        } else {
            detailView.note = DataModel.shared.noteList.first
        }
        let detailViewNavigationController = UINavigationController(rootViewController: detailView)
        splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureDetailView()
    }
}

// MARK: - DataSource

extension NoteTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.noteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            debugPrint(ErrorCase.cellError.localizedDescription)
            return UITableViewCell()
        }
        let note = DataModel.shared.noteList[indexPath.row]
        cell.configure(note)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = DataModel.shared.noteList[indexPath.row]
            DataModel.shared.deleteData(data)
            tableView.reloadData()
        }
    }
}

// MARK: - Delegate

extension NoteTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = DataModel.shared.noteList[indexPath.row]
        showDetailView(about: note)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
