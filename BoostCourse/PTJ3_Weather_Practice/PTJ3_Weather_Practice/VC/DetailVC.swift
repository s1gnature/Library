//
//  DetailVC.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 07/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class DetailVC: UIViewController, UITableViewDataSource{
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var weatherTable: UITableView!
    
    var navigationTitle: String = ""
    var nationEng: String = ""
    
    var cityList: [Cities] = []
    
    func celToFah(_ cel: Int) -> Float{
        return Float(cel * 9 / 5 + 32)
    }
    func selectImg(_ state: Int) -> UIImage {
        switch state {
        case 10:
            return UIImage(named: "sunny")!
        case 11:
            return UIImage(named: "cloudy")!
        case 12:
            return UIImage(named: "rainy")!
        case 13:
            return UIImage(named: "snowy")!
        default:
            return UIImage(named: "flag_kr")!
        }
    }
    func setNationTitleEng(){
        switch navigationTitle {
        case "한국":
            return nationEng = "kr"
        case "일본":
            return nationEng = "jp"
        case "독일":
            return nationEng = "de"
        case "미국":
            return nationEng = "us"
        case "이탈리아":
            return nationEng = "it"
        case "프랑스":
            return nationEng = "fr"
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city: Cities = self.cityList[indexPath.row]
        
        let cell = weatherTable.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! weatherCell
        
        cell.city_lb.text = city.city_name
        cell.rain_lb.text = "강수확률: \(city.rainfall_probability)"
        cell.temp_lb.text = "섭씨: \(city.celsius)" + " / 화씨: \(celToFah(Int(city.celsius)))"
        cell.state_lb.text = "\(city.state)"
        cell.rain_lb.textColor = UIColor.orange
        cell.weather_img.image = selectImg(city.state)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedVC: WeatherDatilVC = segue.destination as? WeatherDatilVC else{
            return
        }
        guard let cell: weatherCell = sender as? weatherCell else{
            return
        }
        selectedVC.city = cell.city_lb.text!
        selectedVC.rain = cell.rain_lb.text!
        selectedVC.weather = cell.weather_img.image!
        selectedVC.temp = cell.temp_lb.text!
        selectedVC.stateNum = Int(cell.state_lb.text!)
    }
    
    override func viewDidLoad() {
        navigationBar.title = navigationTitle
        weatherTable.dataSource = self
        setNationTitleEng()
        
        // kr test data
        // switch as navigationTitle
        let jsonDecoder: JSONDecoder = JSONDecoder()
        

        // 선택한 국가에 따라 할당할 데이터 분기
        guard let dataAsset: NSDataAsset = NSDataAsset(name: nationEng) else{
            return
        }
        do{
            cityList = try jsonDecoder.decode([Cities].self, from: dataAsset.data)
        }catch{
            print("JSON ERROR")
        }
        
        self.weatherTable.reloadData()
        print(nationEng)
    }
}
