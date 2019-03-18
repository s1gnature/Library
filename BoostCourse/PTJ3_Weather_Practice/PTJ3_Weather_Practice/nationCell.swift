//
//  nationCell.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 07/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//
import Foundation
import UIKit

class nationCell: UITableViewCell {

    @IBOutlet var img_nationFlag: UIImageView!
    @IBOutlet var lb_nation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
