//
//  NoteItem+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/22.
//
//

import Foundation
import CoreData


extension NoteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteItem> {
        return NSFetchRequest<NoteItem>(entityName: "NoteItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModifiedDate: Date?

}

extension NoteItem : Identifiable {

}
