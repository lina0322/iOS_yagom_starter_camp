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
    
    init (id: String, password: String,
          profieImage: UIImage, introduction: String,
          phoneNumber: String, dateOfBirth: Date) {
        self.id = id
        self.password = password
        self.profieImage = profieImage
        self.introduction = introduction
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
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

class TempInformation {
    static let common = TempInformation()
    private init() {}
    
    var id: String?
    var password: String?
    var profileImage: UIImage?
    var introduction: String?
    var phoneNumber: String?
    var dateOfBirth: Date?
    
    func clearAll() {
        id = nil
        password = nil
        profileImage = nil
        introduction = nil
        phoneNumber = nil
        dateOfBirth = nil
    }
}

class UserInformation {
    static let common = UserInformation()
    private init() {}
    
    typealias UserId = String
    
    private(set) var userDirectory = [UserId : User]()
    
    func addNewUser(userInformation: TempInformation) {
        guard let id = userInformation.id,
              userDirectory[id] == nil else {
            debugPrint(Message.existedId)
            return
        }
        guard let password = userInformation.password,
              let profileImage = userInformation.profileImage,
              let introduction = userInformation.introduction,
              let phoneNumber = userInformation.phoneNumber,
              let dateOfBirth = userInformation.dateOfBirth else {
            return
        }
        userDirectory[id] = User(id: id, password: password,
                                 profieImage: profileImage, introduction: introduction,
                                 phoneNumber: phoneNumber, dateOfBirth: dateOfBirth)
    }
}

