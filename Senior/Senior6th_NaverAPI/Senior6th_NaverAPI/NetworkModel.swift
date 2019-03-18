//
//  NetworkModel.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation

//통신 기초 모델. 필수. 앞으로의 모델 파일들이 이 파일을 상속받을거임.

// extension UIviewController 안불러왔으므로 gsno 옵셔널 비강제해제 다시 선언해줘야함.
class NetworkModel : NetworkCallback{
    
    //internal -  앱, 모듈, 프레임워크의 내부구조를 칭할때
    
    // 기본 URL -> 제공해줌
    internal let naverAPI = "https://openapi.naver.com/v1/search/movie.json"
    
    var view : NetworkCallback
    
    init(_ view:NetworkCallback){   // NetworkCallback 프로토콜에 init()이 없으므로 required 필요 x
        self.view = view
    }
    
    
    
    // 옵셔널 비강제해제 구문 재 선언
    
    func gsno(_ value:String?)-> String{
        
        if let value_ = value{
            return value_
        }else{
            return ""
        }
        
    }//func gsno
    
    func gino(_ value:Int?) -> Int{
        
        if let value_ = value{
            return value_
        }else{
            return 0;
        }
        
    }//func gino
    
    func gbno(_ value:Bool?)->Bool{
        if let value_ = value{
            return value_
        }else
        {
            return false
        }
        
    }//func gbno
    
    func gfno(_ value:Float?)->Float{
        if let value_ = value{
            return value_
        }else
        {
            return 0
        }
        
    }
    //func gfno
    
    func networkResult(resultData: Any, code: String) {
        
    }
    func networkFailed() {
        print("Error : Network")
    }
}
