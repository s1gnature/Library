//
//  MessageVO.swift
//  Senior5th_cocoapod
//
//  Created by mong on 2017. 8. 16..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import ObjectMapper

class MessageVO : Mappable{
    
    
    var location:String?
    var three_day_forecast : [ForecastVO]? // 배열형식 선언
    // var 3dayforcast : ForecastVD? -> 객체형식 선언
    
    // mappable 사용시 써야할 메소드 -> 초기화
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        three_day_forecast <- map["three_day_forecast"]
    }
}
    
/*
 {
    "location": "Toronto, Canada",
    "three_day_forecast": [
        {
            "conditions": "Partly cloudy",
            "day" : "Monday",
            "temperature": 20
        },
        {
            "conditions": "Showers",
            "day" : "Tuesday",
            "temperature": 22
        },
        {
            "conditions": "Sunny",
            "day" : "Wednesday",
            "temperature": 28
        }
    ]
}

 json 파일 형식
*/
