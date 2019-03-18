//
//  NetworkCallback.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation

protocol NetworkCallback{
    
    func networkResult(resultData : Any, code:String)
    func networkFailed()
}
