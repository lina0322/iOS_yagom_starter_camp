//
//  DataModel.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/26.
//

import UIKit
import CoreData

class DataModel {
    static let shared = DataModel()
    private init() {}
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var noteList: [NSManagedObject] = [] 
    
    func saveData(_ data: String) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
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
        }
    }
    
    func loadCoreData() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: "CloudNote")
        
        do {
            noteList = try managedContext.fetch(request)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error)")
        }
    }
    
    func deleteData(_ data: NSManagedObject) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        managedContext.delete(data)
        do {
            try managedContext.save()
            //navigationController?.popViewController(animated: true)
        } catch {
            print("저장실패")
        }
    }
}
