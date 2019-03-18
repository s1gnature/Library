//
//  VC1.swift
//  Senior4th_twosomeplace
//
//  Created by mong on 2017. 8. 9..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit

class VC1 : UIViewController,UITableViewDelegate,UITableViewDataSource{
    var MusicList = [MusicVO]()
    
    
    @IBAction func testbtn(_ sender: Any) {
        initModel()
    }
    
    @IBOutlet weak var MusicTable: UITableView!
    
    
    func deleteMusic(_ sender:UIButton){
        
        let index = sender.tag
        
        let alert = UIAlertController(title: "Genie", message: "목록에서 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){ _ in
            self.MusicList.remove(at: index)
            self.MusicTable.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell music 코드 고정 사용
        let cell = MusicTable.dequeueReusableCell(withIdentifier: "Musiccell") as! Musiccell
        let Music = MusicList[indexPath.row] //모든 열 참조 가능 ?
        if let Rank_label = Music.Rank_label{cell.Rank_label.text = "\(Rank_label)"}
        if let AlbumArt_img = Music.AlbumArt_img{cell.AlbumArt_img.image = UIImage(named: AlbumArt_img)}
        if let MusicTitle_label = Music.MusicTitle_label{cell.MusicTitle_label.text = "\(MusicTitle_label)"}
        if let Artist_label = Music.Artist_label{cell.Artist_label.text = "\(Artist_label)"}
        if let Artist2_label = Music.Artist2_label{cell.Artist2_label.text = "\(Artist2_label)"}
        
        cell.Trash_btn.tag = indexPath.row
        cell.Trash_btn.addTarget(self, action: #selector(deleteMusic(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = MusicList[indexPath.row]
        
        guard let vc2 = storyboard?.instantiateViewController(withIdentifier: "VC2") as? VC2
            else{return}
        vc2.music = music
        navigationController?.pushViewController(vc2, animated: true)
        
    }
    
    override func viewDidLoad() {
        //initModel()
        // 컨트롤러와 테이블 뷰를 이어줘야함 -> 스토리보드로 이어주는 역할.
        MusicTable.delegate = self
        MusicTable.dataSource = self
    }
    
    func initModel(){
        
        //실제로 앱을 만들 때는 서버에서 배열로 주는 정보
        
        let music1 =  MusicVO(Rank_label: 1, AlbumArt_img: "1", MusicTitle_label: "TOMBOY", Artist_label: "혁오(HYUKOH) |", Artist2_label: "23")
        let music2 = MusicVO(Rank_label: 2, AlbumArt_img: "2", MusicTitle_label: "팔레트(Feat. G-DRANGON", Artist_label:"아이유(IU) 외 |", Artist2_label: "Palette")
        let music3 = MusicVO(Rank_label: 3, AlbumArt_img: "3", MusicTitle_label: "Lonely(Feat.태연)", Artist_label: "종현(JONGHYUN) 외 |", Artist2_label: "종현소품집 '이야기 Op.2")
        let music4 = MusicVO(Rank_label: 4, AlbumArt_img: "4", MusicTitle_label: "이 지금", Artist_label: "아이유 (IU) |", Artist2_label: "Palette")
        let music5 = MusicVO(Rank_label: 5, AlbumArt_img: "5", MusicTitle_label: "가죽자켓", Artist_label: "혁오(HYUKOH) |", Artist2_label: "23")
        let music6 = MusicVO(Rank_label: 6, AlbumArt_img: "6", MusicTitle_label: "이런 엔딩", Artist_label: "아이유 (IU) |", Artist2_label: "사랑이 잘")
        let music7 = MusicVO(Rank_label: 7, AlbumArt_img: "7", MusicTitle_label: "사랑이 잘(With 오혁)" , Artist_label:"아이유 (IU) |", Artist2_label: "사랑이 잘")
        let music8 = MusicVO(Rank_label: 8, AlbumArt_img: "8", MusicTitle_label: "이름에게", Artist_label: "아이유 (IU) |", Artist2_label: "Palette")
        let music9 = MusicVO(Rank_label: 9, AlbumArt_img: "9", MusicTitle_label: "잼잼", Artist_label: "아이유 (IU) |", Artist2_label: "Palette")
        let music10 = MusicVO(Rank_label: 10, AlbumArt_img: "10", MusicTitle_label: "BLUE MOON(Prod. by GroovyRoom)", Artist_label: "효린 & 창모  |", Artist2_label: "BLUE MOON")
        let music11 = MusicVO(Rank_label: 11, AlbumArt_img: "11", MusicTitle_label: "REALLY REALLY", Artist_label: "WINNER", Artist2_label: "FATE NUMBER FOR")
        let music12 = MusicVO(Rank_label: 12, AlbumArt_img:"12", MusicTitle_label:"첫눈처럼 너에게 가겠다", Artist_label:"에일리(Ailee)", Artist2_label:"도깨비 OST Part 9 (tvN 금토드라마)")
        let music13 = MusicVO(Rank_label: 13, AlbumArt_img: "13", MusicTitle_label: "KNOCK KNOCK", Artist_label: "TWICE(트와이스)", Artist2_label: "TWICEcoaster : LANE 2")
        let music14 = MusicVO(Rank_label: 14, AlbumArt_img: "14", MusicTitle_label: "She's a Baby", Artist_label: "지코(ZICO)", Artist2_label: "She's a Baby")
        let music15 = MusicVO(Rank_label: 15, AlbumArt_img: "15", MusicTitle_label: "Marry Me", Artist_label: "구윤회 & 마크툽 (Maktub)", Artist2_label: "마크툽 프로젝트 Vol.3")
        
        
        MusicList+=[music1,music2,music3,music4,music5,music6,music7,music8,music9,music10,music11,music12,music13,music14,music15]
        
    }
}
