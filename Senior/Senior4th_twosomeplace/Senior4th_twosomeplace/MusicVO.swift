//
//  MusicVO.swift
//  Senior4th_twosomeplace
//
//  Created by mong on 2017. 8. 9..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit


// 서버에서 받아오는 곳 ?
class MusicVO{
    init(){}
    init(Rank_label : Int?,AlbumArt_img : String?, MusicTitle_label : String?, Artist_label : String?, Artist2_label : String?){
        self.Rank_label = Rank_label
        self.AlbumArt_img = AlbumArt_img
        self.MusicTitle_label = MusicTitle_label
        self.Artist_label = Artist_label
        self.Artist2_label = Artist2_label
    }
    var Rank_label:Int?
    var AlbumArt_img:String?
    var MusicTitle_label:String?
    var Artist_label:String?
    var Artist2_label:String?
}
