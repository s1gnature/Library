//
//  PhotoDetailVC.swift
//  PTJ4_MyAlbum
//
//  Created by mong on 22/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoDetailVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var favoriteBtn: UIBarButtonItem!
    
    var selectedIndex: [IndexPath] = []
    var image: UIImage?
    var fetchResult: PHFetchResult<PHAsset>!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    @objc func didTouchImage(){
        switch self.imageView.backgroundColor {
        case UIColor.black:
            self.imageView.backgroundColor = UIColor.clear
        case UIColor.clear:
            self.imageView.backgroundColor = UIColor.black
        default:
            return
        }
    }
    func checkFavorite(){
        let isHeart = fetchResult[(selectedIndex.first?.row)!].isFavorite

        switch isHeart {
        case true:
            favoriteBtn.title = "❤️"
        case false:
            favoriteBtn.title = "🖤"
        }
    }
    @IBAction func favoriteBtn(_ sender: Any) {
        let preVC: PhotoListVC = self.navigationController?.viewControllers[1] as! PhotoListVC
        let asset: PHAsset = preVC.fetchResult[(selectedIndex.first?.row)!]
        
        switch favoriteBtn.title {
        case "🖤":
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = true}, completionHandler: {success, _ in
                    OperationQueue.main.addOperation {
                        if success{
                            self.favoriteBtn.title = "❤️"
                        } else{
                            print("Error in favorite")
                        }
                    }
            })
        case "❤️":
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = false}, completionHandler: {success, _ in
                    OperationQueue.main.addOperation {
                        if success{
                            self.favoriteBtn.title = "🖤"
                        } else{
                            print("Error in unfavorite")
                        }
                    }
            })
        default:
            return
        }
    }
    @IBAction func actionBtn(_ sender: Any) {
        var imageList: [UIImage] = []
        imageList.append(imageView.image!)
        let controller = UIActivityViewController.init(activityItems: imageList, applicationActivities: nil)
        controller.excludedActivityTypes = [.postToFacebook, .postToTwitter, .print, .assignToContact]
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func trashBtn(_ sender: Any) {
        let preVC: PhotoListVC = self.navigationController?.viewControllers[1] as! PhotoListVC
        let asset: PHAsset = preVC.fetchResult[(selectedIndex.first?.row)!]
        /*
         MARK: 2/28 delete Photo, reloadData, popViewController
         화면 전환할때 이미 deselectAll() 호출해서 select된 아이템 없음. 그럼 어떻게..?
         이전 VC에서 indexPath 넘겨주고 여기서 삭제 후 reload 시키면 가능할까?
         그럼 아직 해결못한 앨범 cnt 처럼 삭제 후 돌아 갔을때 목록이 그대로 남아있을거같은데.. 이건 reloadData() 로 해결될라나..
         #삭제 후 이전 화면으로 전환해야합니다
         이건 여기 마지막에 self.dismiss 시켜버리면 이전 화면으로 전환되니까
         dismiss이전에 이전 collectionView reload 시키던가 아니면 PhotoListVC 에 viewWillAppear 에다가 reload 해놓으면 될거같은데
         -> 해결
         
         지금 autoLayout을 safeArea기준으로 잡아둠. 그래서 사진이 naviBar & statusBar hidden 시켰을때 safeArea의 변경으로 인해
         사진 위치가 재조정됨. standard Photo app 에서는 superView 에다가 autoLayout 걸어놔서 hidden 시켜도 사진 위치 변경없이
         fullSize 사진이 다 보임. 지금 그게 안댐. 근데 내가 자꾸 수정했을때는 fullSize는 되는데 hidden 안 시켰을때 scroll이 움직임. 수정해야함
         아마 safeArea가 내려옴으로 인해 imageView가 보이는 scrollView보다 크기가 크니까 scroll이 적용되는거같은데 암니어ㅣ부 ㅇㅁㄴㅇ ㅂ몰라..
        */

        /*
         MARK:: handler, _ (언더바) 의 역할
         핸들러는 이제 불러와진 메소드가 일을 다 하고 마무리 하기 전 해야할것들을 (클로저?) 형식으로 코드를 작성하게 해줌. 근데 보통 핸들러 안에
         Bool, Error 같은 형식이 나올텐데 얘네는 메소드가 일을 하고 난 뒤 핸들러에 전달해줄 형식으로보임.
         밑에 코드를 예시로 보면 performChanges 를 하고 이 메소드로 인해 performChanges 되었는지(true) 아니면 실패인지(false) 아니면
         에러가 발생했는지(Error) 를 체크해서 핸들러로 넘겨줘서 추가 코드 진행을 하게 도와줌. 여기서 Bool 형식을 가지는 isDelete 파라미터를 만들어서
         performChanges 되었으면 (사진이 삭제 되었으면) true를 핸들러로 넘겨 reloadData 와 popVC 진행, false를 넘겨주면 if 분기로 인해
         진행 불가.
         근데 핸들러 형식이 Bool, Error 이므로 Error에 대한 파라미터도 있어야 하는데 난 Error 에 대한 예외처리는 안할것, 상관 없으므로 _(언더바) 를 해주면 상관없이 핸들러 수행이 가능함!
        */
        
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: {isDelete, _ in
            if isDelete{
                OperationQueue.main.addOperation {
                    preVC.photoCollectionView.reloadData()
                    isChanged = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }

    override var prefersStatusBarHidden: Bool{
        if (navigationController?.isNavigationBarHidden)!{
            return true
        }else {return false}
    }
    override func viewDidLoad() {
        self.navigationController?.title = "\(String(describing: fetchResult[(selectedIndex.first?.row)!].creationDate))"
        print(self.navigationController?.title)
        self.imageView.image = image
        self.scrollView.delegate = self
        self.navigationController?.hidesBarsOnTap = true
        checkFavorite()
        let tap = UITapGestureRecognizer(target: imageView, action: #selector(self.didTouchImage))
        tap.delegate = self
//        self.view.addGestureRecognizer(tap)
        
        /*
         MARK:: AutoLayout 잡는거 포기.. safeArea로 잡아놨는데 이러면 tap 할때마다 navigationBar 사라짐으로 인해
         safeArea가 변함. 이로인해서 크기가 바껴서 사진이 자꾸 움직임...
        */
//        var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        scrollView.frame.size = CGSize(width: scrollView.frame.width, height: scrollView.frame.height - statusBarHeight)
//        imageView.frame.size = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isToolbarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
    }
}
