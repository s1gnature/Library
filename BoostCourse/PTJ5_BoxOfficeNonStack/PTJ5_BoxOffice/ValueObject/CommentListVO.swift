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
    var rating: Double
    var timestamp: Double
    var writer: String
    var movie_id: String
    var contents: String
    
    init(rating: Double, timestamp: Double, writer: String, movie_id: String, contents: String) {
        self.rating = rating
        self.timestamp = timestamp
        self.writer = writer
        self.movie_id = movie_id
        self.contents = contents
    }
}
