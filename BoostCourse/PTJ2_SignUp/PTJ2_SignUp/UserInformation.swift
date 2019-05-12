//
//  UserInformation.swift
//  PTJ2_SignUp
//
//  Created by mong on 12/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    func reset(){
        ID = ""
        Password = ""
        phoneNumber = ""
        birth = ""
    }
    
    var ID: String?
    var Password: String?
    var phoneNumber: String?
    var birth: String?
}
