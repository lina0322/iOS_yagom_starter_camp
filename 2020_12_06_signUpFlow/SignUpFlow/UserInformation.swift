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

class UserInformation {
    static let common = UserInformation()
    private init() {}
    
    typealias UserID = String
    private(set) var userDirectory = [UserID : User]()
    
    var id: UserID?
    var password: String?
    var profileImage: UIImage?
    var introduction: String?
    var phoneNumber: String?
    var dateOfBirth: Date?
    var recentId: String = ""
    
    func addNewUser() throws {
        guard let id = self.id,
              userDirectory[id] == nil,
              let password = self.password,
              let profileImage = self.profileImage,
              let introduction = self.introduction,
              let phoneNumber = self.phoneNumber,
              let dateOfBirth = self.dateOfBirth else {
            throw SystemError.registrationFailure
        }
        userDirectory[id] = User(id: id, password: password,
                                 profieImage: profileImage, introduction: introduction,
                                 phoneNumber: phoneNumber, dateOfBirth: dateOfBirth)
    }
    
    func clearTempData() {
        id = nil
        password = nil
        profileImage = nil
        introduction = nil
        phoneNumber = nil
        dateOfBirth = nil
    }
}

enum SystemError: Error {
    case registrationFailure
}
