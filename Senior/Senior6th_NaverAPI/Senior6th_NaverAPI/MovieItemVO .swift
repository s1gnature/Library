//
//  MovieItemVO.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieItemVO : Mappable{
    var title : String?
    var image : String?
    var director : String?
    var actor : String?
    var userRating : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        image <- map["image"]
        director <- map["director"]
        actor <- map["actor"]
        userRating <- map["userRating"]
    }
}
