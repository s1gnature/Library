//
//  VC2.swift
//  Senior4th_twosomeplace
//
//  Created by mong on 2017. 8. 9..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit

class VC2 : UIViewController{
    @IBOutlet weak var Rank_label: UILabel!
    @IBOutlet weak var AlbumName_label: UILabel!
    @IBOutlet weak var Artist_label: UILabel!
    @IBOutlet weak var Title_label: UILabel!
    
    @IBOutlet weak var AlbumArt_img: UIImageView!
    
    var music : MusicVO?
    
    override func viewDidLoad() {
        Rank_label.text = "\((music?.Rank_label)!)"
        AlbumName_label.text = music?.Artist2_label!
        Artist_label.text = music?.Artist_label!
        Title_label.text = music?.MusicTitle_label!
        AlbumArt_img.image = UIImage(named: (music?.AlbumArt_img)!)
        
    }
    
}
