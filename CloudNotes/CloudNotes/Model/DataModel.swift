//
//  DataModel.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/26.
//

import UIKit
import CoreData

final class DataModel {
    var noteList: [NSManagedObject] = []
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var managedContext: NSManagedObjectContext {
        return appDelegate!.persistentContainer.viewContext
    }
    static let shared = DataModel()
    private init() {}
    
    func fetchData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: EntityString.entityName)
        let sortType = NSSortDescriptor(key: EntityString.lastModified, ascending: false)
        request.sortDescriptors = [sortType]
        
        do {
            noteList = try managedContext.fetch(request)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error)")
        }
    }
    
    func deleteData(_ data: NSManagedObject) {
        managedContext.delete(data)
        
        do {
            try managedContext.save()
            fetchData()
            NotificationCenter.default.post(name: NSNotification.Name(NoteString.notification), object: nil)
        } catch let error as NSError {
            debugPrint("Could not save. \(error)")
            managedContext.rollback()
        }
    }
    
    func saveData(_ text: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: EntityString.entityName, in: managedContext) else {
            return
        }
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        let splitedData = spliteText(text)
        
        note.setValue(splitedData.title, forKey: EntityString.title)
        note.setValue(splitedData.body, forKey: EntityString.body)
        note.setValue((Date()), forKey: EntityString.lastModified)
        
        do {
            try managedContext.save()
            noteList.insert(note, at: 0)
        } catch let error as NSError {
            debugPrint("Could not save. \(error)")
            managedContext.rollback()
        }
    }
    
    func editData(_ text: String, editInto note: NSManagedObject) {
        let splitedData = spliteText(text)
        
        note.setValue(splitedData.title, forKey: EntityString.title)
        note.setValue(splitedData.body, forKey: EntityString.body)
        note.setValue((Date()), forKey: EntityString.lastModified)
        
        do {
            try managedContext.save()
            fetchData()
            NotificationCenter.default.post(name: NSNotification.Name(NoteString.notification), object: nil)
        } catch let error as NSError {
            debugPrint("Could not save. \(error)")
            managedContext.rollback()
        }
    }
    
    private func spliteText(_ data: String) -> (title: Substring, body: Substring?) {
        let splitedData = data.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        if splitedData.count == 1 {
            return (title: splitedData[0], body: nil)
        }
        return (title: splitedData[0], body: splitedData[1])
    }
}
