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
    private(set) var profieImage: UIImage?
    private(set) var introduction: String?
    private(set) var phoneNumber: String?
    private(set) var dateOfBirth: Date?
    
    init (_ id: String) {
        self.id = id
    }
    
    func setPassword(_ password: String) {
        self.password = password
    }
    
    func setProfieImage(_ profieImage: UIImage) {
        self.profieImage = profieImage
    }
    
    func setIntroduction(_ introduction: String) {
        self.introduction = introduction
    }
    
    func setPhoneNumber(_ phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    func setDateOfBirth(_ dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
    }
}

class UserInformation {
    static let common: UserInformation = UserInformation()
    private init() {}
    
    typealias UserId = String
    
    private(set) var userDirectory = [UserId : User]()
    
    func addNewUser(id: String) {
        guard userDirectory[id] == nil else {
            debugPrint(Message.existedId)
            return
        }
        userDirectory[id] = User(id)
    }
}

