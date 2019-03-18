//
//  ViewController.swift
//  PTJ3_weather
//
//  Created by mong on 03/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableview: UITableView!

    
    // dateFormatter 로 생성된 시간을 add btn을 눌렀을때 2번째 섹션에 추가되게 만듦
    @IBAction func add_btn(_ sender: Any) {
        dates.append(Date())
        
        // tableview 전체를 reload
//        self.tableview.reloadData()
       
        // tableview 전체를 reload 하기엔 자원 낭비가 심하니 추가로 들어가는 2번째 섹션만 reload 시킴. + animation도 추가
        self.tableview.reloadSections(IndexSet(2...2), with: UITableView.RowAnimation.automatic)
    }
    
    
    let cellIdentifier: String = "cell"
    let customCellIdentifier: String = "customCell"
    var dates: [Date] = []
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        return formatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    let korean: [String] = ["가", "나", "다","라","마","바","사","아","자","차","카","타","파","하"]
    let english: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    // tableView 섹션 갯수 지정.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    // 섹션 간 줄수 지정.
    // 0번째 섹션에서는 korean 안의 객체 갯수, 1번째 섹션에선 english 안의 객체 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return korean.count
        case 1:
            return english.count
        case 2:
            return dates.count
        default:
            return 0
        }
    }
    // cell 안에 넣을 내용 생성.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell 재활용 -> ib에서 셀 하나만 넣어줬으므로
        // 테이블 뷰 안에서 같은 셀을 재사용 할 수 있게 해줌
        
        
        // 섹션 넘버가 2보다 작을땐 korean, english를 섹션에 보여주고
        if indexPath.section < 2{
            
            // default cell
            // 위에서 cellIdentifier 를 미리 let 으로 안해뒀으면 여기 밑에서 그냥 "cell" 해도 인식 되는듯
            // 이게 솝트에서 한 방식?
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            
        // 섹션 = 0 일 경우 korean 안의 내용물, 아닐경우 english
        let text: String = indexPath.section == 0 ? korean[indexPath.row] : english[indexPath.row]
        cell.textLabel?.text = text
            return cell
        }
            
            // 섹션 넘버가 2일때는 date 추가
        else{
            
            let cell: CustomViewCell = tableView.dequeueReusableCell(withIdentifier: self.customCellIdentifier, for: indexPath) as! CustomViewCell
            
            // 여기선 셀 하나에 textLabel 지정해뒀기때문에 그냥 냅둬도 기본 textLabel에 text가 들어감.
//            cell.textLabel?.text = self.dateFormatter.string(from: self.dates[indexPath.row])
            // 밑에서 할 거는 left label에는 날짜, right label에는 현재 시간 적을거기때문에 각자 지정해주야함.
            cell.lb_left?.text = self.dateFormatter.string(from: self.dates[indexPath.row])
            cell.lb_right?.text = self.timeFormatter.string(from: self.dates[indexPath.row])
            return cell
        }
    }
    // tableView header 지정.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < 2{
            return section == 0 ? "korean" : "english"
        }
        
        return nil
    }
}

