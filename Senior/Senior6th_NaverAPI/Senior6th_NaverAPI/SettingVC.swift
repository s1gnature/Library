//
//  SettingVC.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 10. 1..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit

class SettingVC : UIViewController{
    let ud = UserDefaults.standard
    
    // 로그아웃 시 자동로그인에 대한 accountSequence 값을 0 으로 초기화 시켜줌으로써 해제시킴
    let accountSequence = 0
    
    @IBAction func Logout_Btn(_ sender: Any) {
        simpleLogout(title: "", message: "로그아웃 하시겠습니까?")
    }
    
    func simpleLogout(title:String, message msg:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"확인",style:.default)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (UIAlertAction) in
            let splash_storyboard = UIStoryboard(name: "SplashLogIn", bundle: nil)
            guard let LogInVC = splash_storyboard.instantiateViewController(withIdentifier: "SplashVC") as? SplashVC else {return}
            // 어카운트시퀀스값 0 초기화
            self.ud.set(self.accountSequence, forKey: "accountSequence")
            self.present(LogInVC, animated: true, completion: nil)
            
        }
    }
        
}
