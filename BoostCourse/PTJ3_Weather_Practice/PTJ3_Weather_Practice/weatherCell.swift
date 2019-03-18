//
//  weatherCell.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 08/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class weatherCell: UITableViewCell {

    @IBOutlet var weather_img: UIImageView!
    @IBOutlet var city_lb: UILabel!
    @IBOutlet var temp_lb: UILabel!
    @IBOutlet var rain_lb: UILabel!
    @IBOutlet var state_lb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
