//
//  NaverMovieVO.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import ObjectMapper

class NaverMovieVO : Mappable{
    var display : Int?
    var items : [MovieItemVO]?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        display <- map["display"]
        items <- map["items"]
    }
}
