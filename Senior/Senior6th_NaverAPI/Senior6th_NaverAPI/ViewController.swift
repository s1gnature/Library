//
//  ViewController.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 8. 23..
//  Copyright © 2017년 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, NetworkCallback{
    
    @IBOutlet weak var tableview_table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieList : [MovieItemVO] = []
    
    let ud = UserDefaults.standard
    
    // 로그아웃 시 자동로그인에 대한 accountSequence 값을 0 으로 초기화 시켜줌으로써 해제시킴
    let accountSequence = 0
    
    @IBAction func Logout_btn(_ sender: Any) {
        simpleLogout(title: "", message: "로그아웃 하시겠습니까?")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // 앱 만들때 기초로 모두 다 씀. -> 통신 시도 기초공사 라고 생각하면됨.
        let model = MovieModel(self)
        model.getMovieInfoFromNaver(query: gsno(searchBar.text))
    }
    
    // 로그아웃 알림창
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
        alert.addAction(okAction)
        alert.addAction(logoutAction)
        present(alert,animated:true)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview_table.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        var row = movieList[indexPath.row]
        
        cell.movie_title.text = gsno(row.title).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.movie_img.imageFromUrl(gsno(row.image), defaultImgPath: "sopt") // defaultImgPath 이미지 없을때 기본이미지 설정
        
        // 기본구문임 좀 외우자 정보 셀로 가져오는거
        cell.movie_actor.text = gsno(row.actor)
        cell.movie_director.text = gsno(row.director)
        cell.movie_rating.text = gsno(row.userRating)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 복붙, MovieCell 인지 HeaderCell 인지 함수에서는 모르기 때문에 MovieCell 로 지정해줌
        if let cell = tableview_table.cellForRow(at: IndexPath(row: indexPath.row, section : 0)) as? MovieCell{
            simpleLogout(title: "네이버 영화정보", message: "제목 : \(gsno(cell.movie_title.text))\n평점 : \(gsno(cell.movie_rating.text)) ")
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0 // 기본 셀 높이
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableview_table.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        return cell.contentView
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "movie-1"{
            
            //객체지정 as? 배열지정 as!
            movieList = resultData as! [MovieItemVO]
            
            //아래 두 코드 유용하게 쓰임
            // 셀 최소 크기
            tableview_table.estimatedRowHeight = 135.0
            // 셀 안의 데이터에 따라 유동적으로 크기 조정
            tableview_table.rowHeight = UITableViewAutomaticDimension
            
            
            tableview_table.reloadData()
        }
    }
    func networkFailed() {
        simplerAlert(title: "에러", message: "네트워크 연결 지연")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 뷰 빈 셀 꼴보기싫은 줄 없에는거
        tableview_table.tableFooterView = UIView.init(frame : CGRect.zero
        )
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableview_table.dataSource = self
        tableview_table.delegate = self
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

