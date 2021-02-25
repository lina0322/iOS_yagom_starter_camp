//
//  NoteTableViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/15.
//

import UIKit
import CoreData

final class NoteTableViewController: UITableViewController {
    private var noteList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        loadCoreData()
        registerCell()
        configureNavigationItem()
    }
    
    private func loadCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contextRequest = NSFetchRequest<NSManagedObject>(entityName: NoteString.entityName)
        
        do {
            noteList = try managedContext.fetch(contextRequest)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error)")
        }
    }
    
    private func registerCell() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddButton))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = NoteString.memo
    }
    
    @objc private func touchUpAddButton() {
        let detailView = DetailViewController()
        splitViewController?.showDetailViewController(detailView, sender: nil)
        
        saveData("새로운 메모 \n 추가 텍스트 없음")
        tableView.reloadData()
    }
    
    private func saveData(_ data: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: NoteString.entityName, in: managedContext) else {
            return
        }
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        let splitedData = data.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        
        note.setValue(splitedData[0], forKey: EntityString.title)
        note.setValue(splitedData[1], forKey: EntityString.body)
        note.setValue((Date()), forKey: EntityString.lastModified)
        
        do {
            try managedContext.save()
            noteList.append(note)
        } catch let error as NSError {
            debugPrint("Could not save. \(error)")
        }
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
        guard let noteTitle = noteList[indexPath.row].value(forKey: EntityString.title) as? String, let noteBody = noteList[indexPath.row].value(forKey: EntityString.body) as? String else {
            return
        }
        detailView.noteTitle = noteTitle
        detailView.noteBody = noteBody
        detailView.noteIndex = indexPath.row
        splitViewController?.showDetailViewController(detailView, sender: nil)
    }
}
