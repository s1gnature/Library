//
//  ViewController.swift
//  PTJ4_AsncOperationQueue
//
//  Created by mong on 10/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    let smallImage: UIImage = UIImage(named: "shark")!
    
    @IBAction func downloadBtn(_ sender: Any) {
        
        self.imageView.image = smallImage
        
        guard let largeImageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg") else{
            print("largeImage Fail")
            return}
        
        // operationQueue를 사용하므로써 작업을 백그라운드(다른 쓰레드)로 넘겨 downloadBtn 이 프리징 되는 현상을 막음.
        OperationQueue().addOperation {
            let largeImageData: Data = try! Data.init(contentsOf: largeImageURL)
            let largeImage: UIImage = UIImage(data: largeImageData)!
            OperationQueue.main.addOperation {
                self.imageView.image = largeImage
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

