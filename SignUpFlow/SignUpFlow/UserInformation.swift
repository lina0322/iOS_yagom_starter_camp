//
//  SignUpFlow - ViewController.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation
import UIKit

class User {
    let id: String?
    private(set) var password: String?
    private(set) var image: UIImage?
    private(set) var introduction: String?
    private(set) var phoneNumber: String?
    private(set) var dateOfBirth: Date?
    
    init (_ id: String) {
        self.id = id
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func setIntroduction(introduction: String) {
        self.introduction = introduction
    }
    
    func setPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    func setDateOfBirth(dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
    }
}

class UserInformation {
    static let common: UserInformation = UserInformation()
    private init() {}
    
    private(set) var userList = [String : User]()
    
    func addNewUser(id: String) {
        guard let _ = userList[id] else {
            debugPrint("이미 존재하는 아이디입니다")
            return
        }
        userList[id] = User(id)
    }
}
