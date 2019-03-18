//
//  ViewController.swift
//  PTJ3_Weather_Practice
//
//  Created by mong on 07/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet var nation_tableView: UITableView!
    
    var nationList: [Nation] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nation: Nation = self.nationList[indexPath.row]
        
        let cell = nation_tableView.dequeueReusableCell(withIdentifier: "nationCell", for: indexPath) as! nationCell

        cell.lb_nation.text = nation.korean_name

        switch cell.lb_nation.text{
        case "한국":
            cell.img_nationFlag.image = UIImage(named: "flag_kr")
        case "일본":
            cell.img_nationFlag.image = UIImage(named: "flag_jp")
        case "독일":
            cell.img_nationFlag.image = UIImage(named: "flag_de")
        case "이탈리아":
            cell.img_nationFlag.image = UIImage(named: "flag_it")
        case "미국":
            cell.img_nationFlag.image = UIImage(named: "flag_us")
        case "프랑스":
            cell.img_nationFlag.image = UIImage(named: "flag_fr")
        default:
            return cell
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nation_tableView.dataSource = self
        
        // countries
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else{
            return
        }
        do{
            nationList = try jsonDecoder.decode([Nation].self, from: dataAsset.data)
        }catch{
            print("JSON ERROR")
        }
        self.nation_tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedVC: DetailVC = segue.destination as? DetailVC else{
            return
        }
        guard let cell: nationCell = sender as? nationCell else{
            return
        }
        selectedVC.navigationTitle = cell.lb_nation.text!
    }

}

