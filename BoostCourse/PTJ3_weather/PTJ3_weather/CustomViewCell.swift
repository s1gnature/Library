//
//  CustomViewCell.swift
//  PTJ3_weather
//
//  Created by mong on 03/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {
    @IBOutlet var lb_left: UILabel!
    @IBOutlet var lb_right: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
