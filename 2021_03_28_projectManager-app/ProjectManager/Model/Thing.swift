//
//  Thing.swift
//  ProjectManager
//
//  Created by 임성민 on 2021/03/09.
//

import Foundation
import CoreData

class Thing: NSManagedObject, Codable {
    var id: Int32?
    @NSManaged var title: String
    @NSManaged var body: String
    var deadline: Double?
    var lastModified: Double?
    @NSManaged var state: String
    var dateString: String {
        return DateFormatter.convertToUserLocaleString(date: date)
    }
    var date: Date {
        guard let deadline = deadline else {
            return Date()
        }
        return Date(timeIntervalSince1970: TimeInterval(deadline))
    }
    var parameters: [String : Any] {[
        "id": id ?? 0,
        "title": title,
        "body": body,
        "deadline": deadline ?? 0,
        "last_modified": lastModified ?? 0,
        "state": state
    ]}
    
    enum CodingKeys: String, CodingKey {
        case id, title, state, body
        case dateNumber = "deadline"
        case lastModified = "last_modified"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: Strings.thing, in: CoreDataStack.shared.persistentContainer.viewContext) else {
            fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: CoreDataStack.shared.persistentContainer.viewContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(deadline, forKey: .dateNumber)
        try container.encode(lastModified, forKey: .lastModified)
        try container.encode(state, forKey: .state)
    }
}
