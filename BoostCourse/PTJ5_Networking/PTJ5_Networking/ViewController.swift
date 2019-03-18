//
//  ViewController.swift
//  PTJ5_Networking
//
//  Created by mong on 07/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "friendCell"
    var friends: [Friend] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let friend: Friend = self.friends[indexPath.row]
        
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        cell.imageView?.image = nil
        
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
        
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell){
                    if index.row == indexPath.row{
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestFriends()
    }
    @objc func didReceiveFriendsNotification(_ noti: Notification){
        
        guard let friends: [Friend] = noti.userInfo?["friends"] as? [Friend] else { return }
        
        self.friends = friends
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveFriendsNotification(_:)), name: DidReceiveFriendsNotification, object: nil)
    }


}

