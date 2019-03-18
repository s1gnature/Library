//
//  weatherDetailVC.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 08/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class WeatherDatilVC: UIViewController {
    var rain: String = ""
    var temp: String = ""
    var state: String = ""
    var city: String = ""
    var stateNum: Int?
    var weather: UIImage?
    
    @IBOutlet var weather_img: UIImageView!
    @IBOutlet var weather_lb: UILabel!
    @IBOutlet var temp_lb: UILabel!
    @IBOutlet var rain_lb: UILabel!
    
    func selectWeather(_ state: Int) -> String{
        switch state {
        case 10:
            return "맑음"
        case 11:
            return "흐림"
        case 12:
            return "비"
        case 13:
            return "눈"
        default:
            return "불러올 수 없음!"
        }
    }
    
    override func viewDidLoad() {
        rain_lb.text = rain
        temp_lb.text = temp
        weather_img.image = weather
        
        weather_lb.text = selectWeather(stateNum!)
        navigationItem.title = city
        
    }
    
}
