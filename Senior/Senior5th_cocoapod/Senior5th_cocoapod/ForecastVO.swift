//
//  ForecastVO.swift
//  Senior5th_cocoapod
//
//  Created by mong on 2017. 8. 16..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import ObjectMapper

// JSON 할때 작은거 부터 만들고 큰걸 만들어야 오류 방지 가능

class ForecastVO : Mappable{
    var conditions : String?
    var day : String?
    var temperature : Int?
    
    
    
    // mappable 쓸때 무조건 있어야하는 메소드 -> 초기화
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        conditions <- map["conditions"]
        day <- map["day"]
        temperature <- map["temperature"]
    }
    
    
}
