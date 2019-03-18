//
//  MovieModel.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class MovieModel : NetworkModel{
    
    func getMovieInfoFromNaver(query :String){
        
        // API 인증키 헤더 (호출)
        let header : HTTPHeaders = [
        "X-Naver-Client-Id" : "cT6GC6xFZjMHKqI5itVI",
        "X-Naver-Client-Secret" : "YrE73eUwX2"
        ]
        let body = [
            "query" : query,
            "display" : 50
        ] as [String : Any]
        Alamofire.request(naverAPI, method: .get, parameters:body, encoding : URLEncoding.queryString, headers:header).responseObject { (response : DataResponse<NaverMovieVO>) in
            switch response.result{
            case .success :
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                // let movies 를 사용하기 위한 if 구문.
                if let movies = message.items{
                    self.view.networkResult(resultData: movies, code: "movie-1")
                }
            case .failure(let err) :
                self.view.networkFailed()
                print(err)
            }
        }
    }
}
