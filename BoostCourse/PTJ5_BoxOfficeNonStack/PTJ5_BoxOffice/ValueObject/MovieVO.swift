//
//  MovieVO.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 08/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation

struct APIResonse: Codable {
    let movies: [Movie]
}
struct Movie: Codable {
    let grade: Int
    let thumb: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
    
    var descriptionForTable: String {
        return "평점: " + "\(user_rating)" + ", 예매순위: " + "\(reservation_grade)" + ", 예매율: " + "\(reservation_rate)"
    }
    var descriptionForCollection: String {
        return "\(grade)위" + "(\(user_rating)) / " + "\(reservation_rate)%"
    }
}
