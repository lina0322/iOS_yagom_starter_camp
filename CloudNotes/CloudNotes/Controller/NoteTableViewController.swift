//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit
import CoreData

final class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private var noteList = [Note]()
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        registerCell()
        configureNavigationItem()
    }
    
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewItem))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = NoteString.memo
    }
    
    @objc private func insertNewItem() {
        let context = fetchedResultsController.managedObjectContext
        let newNote = NoteItem(context: context)
        
        newNote.lastModifiedData = Date()
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
    
    var fetchedResultsController: NSFetchedResultsController<NoteItem> {
        
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
    }
}
