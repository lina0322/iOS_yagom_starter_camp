
import Foundation
import UIKit

class UserInformation {
    static let common: UserInformation = UserInformation()
    
    private init() {}
    
    private(set) var userList = [String : User]()
    
    func addNewUser(id: String, user: User) {
        userList[id] = user
    }
}


