//
//  ViewController.swift
//  Senior5th_cocoapod
//
//  Created by mong on 2017. 8. 16..
//  Copyright © 2017년 mong. All rights reserved.
//

import UIKit
// 통신 alamofire 가져오기
import Alamofire
import AlamofireObjectMapper
import ButtonBackgroundColor

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var location_label: UILabel!

    @IBOutlet weak var Weather_table: UITableView!
    
    @IBOutlet weak var btn: UIButton!
    
    
    // 변수 값이 확실할때는 옵셔널 X -> 확실하지않을때 (값을 넣지 않고 선언할 때) 는 옵셔널을 걸어준다
    let URL : String = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
    
    var threedaysForecast : [ForecastVO] = [ForecastVO]()
    var location : String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 배열명.count -> 습관 들일것.
        
        return threedaysForecast.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let 선언 두 구문 외워둘것. 반드시 필요
        let forecast = threedaysForecast[indexPath.row]
        let cell = Weather_table.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        
        cell.Day_label.text = forecast.day!
        cell.Condition_label.text = forecast.conditions!
        cell.Temp_label.text = "\((forecast.temperature)!)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //btn = UIButton(type: .custom)
        btn.backgroundColorForStates(normal: UIColor.brown, highlighted: UIColor.blue)
        
        Weather_table.delegate = self
        Weather_table.dataSource = self
        
        //data 통신 구문
        Alamofire.request(URL).responseObject{
            (response : DataResponse<MessageVO>) in
            
            // response.result -> .success & .failure 은 서버에서 반환 해주는 결과값
            switch response.result{
            case .success:
            
                guard let forecast = response.result.value else {return}
            
                if let forecasts = forecast.three_day_forecast{
                    // 서버로 부터 받아온 데이터들을 우리가 선언한 변수에 담아준다.
                    // self 안해주면 location 이 어떤 location변수 인지 모르기때문에 VC (이곳) 에서 선언한 변수
                    // 임을 선언하려면 self."변수명" 으로 선언
                    
                    self.location = forecast.location
                    self.threedaysForecast = forecasts
                    self.location_label.text = self.location
                }
                self.Weather_table.reloadData()
            
            case .failure(let err):
                print(err)
            
            }
        }
    }
    
}


