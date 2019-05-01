//
//  ChatVO.swift
//  firebaseChatApp
//
//  Created by mong on 01/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class ChatVO: NSObject {
    public var userList: Dictionary<String,Bool> = [:]
    public var commentList: Dictionary<String,comment> = [:]
    
    public var comment: comment?
}
class comment: NSObject {
    public var uid: String?
    public var message: String?
}
