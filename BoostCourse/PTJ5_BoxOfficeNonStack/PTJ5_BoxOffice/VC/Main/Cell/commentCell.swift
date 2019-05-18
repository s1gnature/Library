//
//  commentCell.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 13/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class commentCell: UITableViewCell {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userID: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var cosmosRateView: CosmosView!
    
}
