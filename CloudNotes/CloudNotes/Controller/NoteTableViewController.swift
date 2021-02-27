//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit
import CoreData

final class NoteTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        registerCell()
        configureNavigationItem()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(NoteString.editData), object: nil)
    }
    
    @objc func reloadTableView(_ notification:Notification) {
        tableView.reloadData()
        configureDetailView()
        configureDetailViewNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataModel.shared.fetchData()
        configureDetailView()
        configureDetailViewNavigationBar()
    }
    
    // MARK: - UI
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddButton))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = NoteString.memo
    }
    
    private func configureDetailViewNavigationBar() {
        let detailView = DetailViewController()
        if (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .pad) {
            let detailViewNavigationController = UINavigationController(rootViewController: detailView)
            splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        }
    }
    
    @objc private func touchUpAddButton() {
        let detailView = DetailViewController()
        DataModel.shared.saveData("제목 \n 내용")
        detailView.note = DataModel.shared.noteList.first
        splitViewController?.showDetailViewController(detailView, sender: nil)
        let detailViewNavigationController = UINavigationController(rootViewController: detailView)
        splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        tableView.reloadData()
    }
    
    private func configureDetailView() {
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        
        if isPad {
            let detailView = DetailViewController()
            detailView.note = DataModel.shared.noteList.first
            splitViewController?.showDetailViewController(detailView, sender: nil)
        }
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
        let detailView = DetailViewController()
        detailView.note = DataModel.shared.noteList[indexPath.row]
        let detailViewNavigationController = UINavigationController(rootViewController: detailView)
        splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}
