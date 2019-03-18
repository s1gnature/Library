//
//  SplashVC.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 9. 27..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit

class SplashVC : UIViewController{
    let ud = UserDefaults.standard
    var delayInSeconds = 1.0
    
    
    
    override func viewDidLoad() {
        let accountSequence = self.ud.integer(forKey: "accountSequence")
        print("어카운트시퀀스")
        print(accountSequence)
        
        //2초뒤에 화면 전환 시켜줌 -> 클로저 구문 사용 
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delayInSeconds){
            
            if accountSequence == 150621 {
                //스토리보드 객체 생성
                let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
                //메인 뷰컨트롤러 접근
                guard let main = main_storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
                self.present(main, animated: true)
            }
            else{
                guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") else {return}
                self.present(logInVC, animated: true, completion: nil)
            }
        }
    }
    
}
