//
//  ImageZoomViewController.swift
//  PTJ4_Album
//
//  Created by mong on 11/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImageZoomViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    override func viewDidLoad() {
        self.scrollView.delegate = self
        super.viewDidLoad()
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            self.imageView.image = image
            })
    }
    
}
