//
//  City.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 08/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
/*
 state
 10: sunny
 11: cloudy
 12: rainy
 13: snow
{
    "city_name":"베를린",
    "state":12,
    "celsius":10.8,
    "rainfall_probability":60
},
*/

struct Cities: Codable{
    let city_name: String
    let state: Int
    let celsius: Float
    let rainfall_probability: Int
}

