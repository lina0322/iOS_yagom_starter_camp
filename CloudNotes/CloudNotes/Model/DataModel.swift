//
//  DataModel.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/26.
//

import UIKit
import CoreData

class DataModel {
    var noteList: [NSManagedObject] = []
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext: NSManagedObjectContext {
        return appDelegate!.persistentContainer.viewContext
    }
    static let shared = DataModel()
    private init() {}
    
    func fetchData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: EntityString.entityName)
        
        do {
            noteList = try managedContext.fetch(request)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error)")
        }
    }
    
    func saveData(_ data: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: EntityString.entityName, in: managedContext) else {
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
            managedContext.rollback()
        }
    }
    
    func deleteData(_ data: NSManagedObject) {
        managedContext.delete(data)
        do {
            try managedContext.save()
            //navigationController?.popViewController(animated: true)
            fetchData()
            NotificationCenter.default.post(name: NSNotification.Name("DeleteData"), object: nil)
        } catch let error as NSError {
            debugPrint("Could not save. \(error)")
            managedContext.rollback()
        }
    }
}
