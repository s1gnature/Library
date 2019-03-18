//
//  CommentListVO.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 13/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation

struct CommentResponse: Codable {
    let movie_id: String
    let comments: [Comment]
}
struct Comment: Codable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movie_id: String
    let contents: String
}
