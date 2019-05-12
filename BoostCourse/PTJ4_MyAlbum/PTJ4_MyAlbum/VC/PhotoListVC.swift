//
//  PhotoListVC.swift
//  PTJ4_MyAlbum
//
//  Created by mong on 17/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var sortTitleBtn: UIBarButtonItem!
    @IBOutlet var actionBtn: UIBarButtonItem!
    @IBOutlet var trashBtn: UIBarButtonItem!
    
    
    @IBOutlet var selectTitleBtn: UIBarButtonItem!
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var identifier: String!
    var albumName: String!
    var passImage: UIImage!
    var selectPhotoNum: Int!
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else{ return}
        
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.deselectAll()
            self.photoCollectionView.reloadSections(IndexSet(0...0))
            isChanged = true
        }
    }
    @IBAction func refreshBtn(_ sender: Any) {
        self.photoCollectionView.reloadSections(IndexSet(0...0))
        deselectAll()
    }
    
    func deselectUI(indexPath: IndexPath){
        let cell = photoCollectionView.cellForItem(at: indexPath)
        cell?.alpha = 1
        cell?.layer.borderWidth = 0
    }
    func deselectAll(){
        let selectedIndex = photoCollectionView.indexPathsForSelectedItems
        for indexPath in selectedIndex! {
            photoCollectionView.deselectItem(at: indexPath, animated: true)
            deselectUI(indexPath: indexPath)
        }
        selectTitleBtn.title = "선택"
        navigationBar.title = albumName
        photoCollectionView.allowsMultipleSelection = false
        actionBtn.isEnabled = false
        trashBtn.isEnabled = false

    }
    @IBAction func trashBtn(_ sender: Any) {
        // MARK:: Delete Photo
        let selectedIndex = photoCollectionView.indexPathsForSelectedItems
        // 단일 항목 제거는 asset = fetchResult[indexPath.row] 로 개별 삭제.
        // 묶음 항목 제거는 asset 을 array로 묶어서 item을 append 시켜서 delete 요청
        var asset: [PHAsset] = []
        for indexPath in selectedIndex! {
            asset.append(fetchResult[indexPath.row])
        }
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(asset as NSArray)}, completionHandler: nil)
    }
    
    @IBAction func actionBtn(_ sender: Any) {
        let selectedIndex = photoCollectionView.indexPathsForSelectedItems
        var imageList: [UIImage] = []
        for indexPath in selectedIndex! {
            let cell: PhotoListCell = photoCollectionView.cellForItem(at: indexPath) as! PhotoListCell
            imageList.append(cell.photoImage.image!)
        }
        let controller = UIActivityViewController.init(activityItems: imageList, applicationActivities: nil)
        controller.excludedActivityTypes = [.postToFacebook, .postToTwitter, .print, .assignToContact]
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func selectBtn(_ sender: Any) {
        switch selectTitleBtn.title {
        case "선택":
            selectTitleBtn.title = "취소"
            navigationBar.title = "항목 선택"
            photoCollectionView.allowsMultipleSelection = true
            
        case "취소":
            deselectAll()
        default:
            return
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // multiSelection이 false 일때만 present , true 일땐 ㄴㄴ
        if ( photoCollectionView.allowsMultipleSelection != true ){
            // MARK:: 아랫쪽 prepare이랑 연결됩니당. 참고해주세요
            let cell: PhotoListCell = photoCollectionView.cellForItem(at: indexPath) as! PhotoListCell
            performSegue(withIdentifier: "showPhoto", sender: cell)
            return
        }
        if (photoCollectionView.indexPathsForSelectedItems?.count != 0 ) {
            actionBtn.isEnabled = true
            trashBtn.isEnabled = true
        } else {
            actionBtn.isEnabled = false
            trashBtn.isEnabled = false
        }
        
        selectPhotoNum = photoCollectionView.indexPathsForSelectedItems?.count
        navigationBar.title = "\(selectPhotoNum!)장 선택"
        
        let cell = photoCollectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.4
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.blue.cgColor
        
        print("selected!")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectPhotoNum = photoCollectionView.indexPathsForSelectedItems?.count
        if selectPhotoNum == 0 {
            navigationItem.title = "항목 선택"
        } else{
            navigationBar.title = "\(selectPhotoNum!)장 선택"
        }
        deselectUI(indexPath: indexPath)
        if (photoCollectionView.indexPathsForSelectedItems?.count != 0 ) {
            actionBtn.isEnabled = true
            trashBtn.isEnabled = true
        } else {
            actionBtn.isEnabled = false
            trashBtn.isEnabled = false
        }
        print("Deselected?")
    }
    @IBAction func sortBtn(_ sender: Any) {
        let fetchOptions = PHFetchOptions()
        switch sortTitleBtn.title {
        case "과거순":
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            sortTitleBtn.title = "최신순"
        case "최신순":
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            sortTitleBtn.title = "과거순"
        default:
            return
        }

        OperationQueue.main.addOperation {
            let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.identifier], options: nil)
            
            let cameraRollCollection = cameraRoll.firstObject
            
            self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection!, options: fetchOptions)
            self.photoCollectionView.reloadSections(IndexSet(0...0))
        }
        deselectAll()
    }
    func requestCollection(){
        let fetchOptions = PHFetchOptions()
        // ascending -> 정렬 ( 최신순, 늦은순 )
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        // 2/21 MARK:: Get Specific Album
        /* 일반적인 앨범 불러오기는 아래 메소드로 불러왔으나
         let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            우리가 가져와야할건 특정 앨범 이므로 LocalIdentifier 을 각 셀에 변수로 저장해서 현 VC 로 넘겨주어 특정앨범 불러와서 사진 Load 함.
            내가 자꾸 헤맸던건 option 에 fetchOption을 자꾸 줘서 뻑나는거였음. 앨범 하나! 를 불러 왔으므로 그게 fetchOption이 먹힐리가
            없는데 자꾸 정렬하려고 드니까 뻑나는거같음
        */
        OperationQueue().addOperation {
            let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.identifier], options: nil)
            
            // 어차피 item이 하나밖에 없으므로 firstObject 를 하나 lastObject 를 하나 동일한 결과가 나옴
            // print(cameraRoll.count) -> 1 나와욧
            let cameraRollCollection = cameraRoll.firstObject
            
            self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection!, options: fetchOptions)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoListCell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCell
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        
        //MARK:: request photo's full size :: targetSize -> PHImageManagerMaximumsize
        // 풀사이즈로 불러오게되면 사진 크기가 너무 커서 로드할때 reusableCell이 겹쳐져 뻑나는거같음.
        // 일단 deviceScreenSize로 불러오긴했는데...
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), contentMode: .aspectFill, options: nil, resultHandler: {image, _ in
                cell.photoImage?.image = image
                })
        return cell
    }
    
    // 2/24 MARK:: Prepare -> Send data to nect VC
    // prepare 은 segue가 실행되었을시에, 화면 전환이 이루어질때 data등의 값을 넘겨주기위해 호출함.
    // prepare 자체로 무언가 실행되는 구문이 아니라 performSegue 했을시에 불러지는 delegate? 라고 봐야하나..?
    // 그래서 위에 performSegue 했을데 sender가 있는데 이 sender에 자꾸 내가 값을 안 넣어 주니까
    // 여기 prepare 에서 cell: = sender as! PhotoListCell 이라고 했을때 뻑나는거임.
    // 위에 performSegue에 sender를 photoCollectionView.cellForItem(at: indexPath) 로 지정해줘서 이쪽에서 받아쓸수있었음.
    // 그렇다고 sender을 any, nil 로 주고 여기서 cellForItem을 사용하기엔 indexPath를 모르니까 위에서 정해주고 sender로 보내버리는게 나을듯
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier == "showPhoto") && (photoCollectionView.allowsMultipleSelection != true)){
            let PhotoDetailVC: PhotoDetailVC = segue.destination as! PhotoDetailVC
            let cell: PhotoListCell = sender as! PhotoListCell
            
            PhotoDetailVC.selectedIndex = photoCollectionView.indexPathsForSelectedItems!
//            let asset: PHAsset = fetchResult.object(at: (photoCollectionView.indexPathsForSelectedItems?.first)!.row)
//            self.imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil, resultHandler: {image, _ in
//                PhotoDetailVC.image = image
//            })
            PhotoDetailVC.image = cell.photoImage.image
            PhotoDetailVC.fetchResult = self.fetchResult
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        actionBtn.isEnabled = false
        trashBtn.isEnabled = false
        photoCollectionView.allowsSelection = true
        photoCollectionView.allowsMultipleSelection = false
        sortTitleBtn.title = "과거순"
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        requestCollection()
        let flowLayout: UICollectionViewFlowLayout
        let photoLength: CGFloat = UIScreen.main.bounds.width / 3.0 - 4

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        
        flowLayout.itemSize = CGSize(width: photoLength, height: photoLength)
        
        self.photoCollectionView.collectionViewLayout = flowLayout
        
        navigationBar.title = albumName
        navigationController?.isToolbarHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = true
        deselectAll()
    }
}
