//
//  PhotoCollectionViewCell.swift
//  PTJ4_MyAlbum
//
//  Created by mong on 17/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var photoCntLabel: UILabel!
    var identifier: String!

}
