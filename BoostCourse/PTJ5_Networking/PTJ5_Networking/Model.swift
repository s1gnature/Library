//
//  Model.swift
//  PTJ5_Networking
//
//  Created by mong on 07/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation

struct APIResponse: Codable{
    let results: [Friend]
}

struct Friend: Codable{
    let name: Name
    let email: String
    let picture: Picture
    
    struct Name: Codable{
        let title: String
        let first: String
        let last: String
        
        var full: String{
            return self.title.capitalized + ". " + self.first.capitalized + " " + self.last.capitalized
        }
    }
    struct Picture: Codable{
        let large: String
        let medium: String
        let thumbnail: String
        
    }
}
