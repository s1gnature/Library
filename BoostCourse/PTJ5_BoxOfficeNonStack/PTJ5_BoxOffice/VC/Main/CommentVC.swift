//
//  commentVC.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 13/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

// 한줄평 닉네임 저장은 유저 디폴트로 하면 될듯한데..
let userDefault: UserDefaults = UserDefaults.init()

class CommentVC: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieGrade: UIImageView!
    @IBOutlet var rateSliderData: UILabel!
    @IBOutlet var starRate: CosmosView!
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var commentTextField: UITextField!
    
    var mtitle: String!
    var grade: UIImage!
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func writeBtn(_ sender: Any) {
        if ((nicknameTextField.text?.isEmpty)! || (commentTextField.text?.isEmpty)!){
            let alert = UIAlertController.init(title: "", message: "빈칸을 확인해 주세요", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController.init(title: "", message: "한줄평 작성 완료", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: {(_) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        print(mtitle)
        movieTitle.text = mtitle
        movieGrade.image = grade
        
        // 별모양 점수표시 슬라이더랑 뭐 그런걸로 내가 만들기 보다 그냥 pod 파일 하나 구해서 가져옴.. Cosmos
        starRate.didTouchCosmos = { (_) in
            self.rateSliderData.text = String(Int(self.starRate.rating * 2))
        }
        nicknameTextField.layer.borderColor = UIColor.blue.cgColor
        nicknameTextField.layer.borderWidth = 1
        nicknameTextField.layer.masksToBounds = true
        nicknameTextField.layer.cornerRadius = 10
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 10
        commentTextField.layer.borderColor = UIColor.orange.cgColor
        
        // statusBar background color
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBarView.backgroundColor = navigationBar.barTintColor
//        UIApplication.shared.statusBarStyle = .lightContent
//        self.setNeedsStatusBarAppearanceUpdate()
    }
}
