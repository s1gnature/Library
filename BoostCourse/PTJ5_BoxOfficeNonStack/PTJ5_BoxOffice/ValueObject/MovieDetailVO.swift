//
//  MovieDetailVO.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 12/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation

//struct APIResponse: Codable {
//    let movie: MovieDetail
//}

struct MovieDetail: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
    
    var audienceComma: String {
        // 11676822 -> 11,676,822
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        var baseNum: Int = audience
        let formmatted = numFormatter.number(from: "\(baseNum)")
        let stringFormmatted = numFormatter.string(from: formmatted!)
        return stringFormmatted!
    }
}
