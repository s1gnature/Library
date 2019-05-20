//
//  ViewController.swift
//  PTJ4_MyAlbum
//
//  Created by mong on 17/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Photos
var isChanged: Bool = false
var enterText: String = ""
let deviceWidth = UIScreen.main.bounds.width

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else{ return}
        
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue().addOperation {
            self.fetchAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        }
        self.collectionView.reloadSections(IndexSet(0...0))
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationItem!

    let albumSize: CGFloat = (UIScreen.main.bounds.width / 2.0) - 20.0
    var fetchAlbum: PHFetchResult<PHAssetCollection>!
    var fetchCameraRoll: PHFetchResult<PHAssetCollection>!
    var fetchResult: PHFetchResult<PHAsset>!
    
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var selectedIndex: [IndexPath] = []

    let fetchOptions = PHFetchOptions()

    var albumCollection: PHAssetCollection!
    var thumbnail: PHAsset!
    func requestPhotos(){
        fetchAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        fetchCameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        albumCollection = self.fetchCameraRoll.firstObject!
        self.fetchResult = PHAsset.fetchAssets(in: albumCollection, options: fetchOptions)
        thumbnail = self.fetchResult.lastObject!
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.reloadSections(IndexSet(0...0))
        }
        
    }
    
    func photoAuthoriztion() -> Bool {
        let photoAuthorizationbStatus = PHPhotoLibrary.authorizationStatus()
        
        
        switch photoAuthorizationbStatus {
        case .authorized:
            print("Access")
            requestPhotos()
            collectionView.reloadData()
            collectionView.reloadSections(IndexSet(0...0))
            return true
            
        case .denied:
            print("Denied")
            return false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    self.requestPhotos()
                default:
                    break
                }
            })
            print("Not Response")
            return false
        case .restricted:
            print("Access Restricted")
            return false
        default:
            return false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let album = self.fetchAlbum{
            return album.count + 1
        }else{
            return 0
        }
//        return (self.fetchAlbum.count + 1)
    }
    
    // collectionViewHeader setting
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: CollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! CollectionViewHeaderCell

        headerView.headerTitle.text = "Album"

        return headerView
    }
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 셀에 초기화할 각 앨범 목록을 가져옴.
        /*
         MARK:: 3/4 cameraRoll & userAlbum 가져오기
         fetchAssetColleciton 에서 with: .album -> User가 생성한 Album만 가져옵니다(정적앨범)
                                with: .smartAlbum -> Photo 앱에서 생성하는 동적인 모든 앨범을 가져옵니다 (addRecent, deleted, 등등)
         내가 필요한건 개인 앨범목록과 camaraRoll 이 필요했음. 두개를 동시에 가져오는건 불가능한걸로 보여서 fetchAlbum, fetchCameraRoll 두가지
         가져와서 collectionView에 뿌려줄때 numberOfItem 은 fetchAlbum.count + 1 로 셀 겟수를 늘리고
         cellForItemAt의 제일 처음 indexPath 에다가 fetchCameraRoll을 해줬다.
         이때 switch 분기를 통해서 indexPath.row == 0 일때는 cameraRoll 을 해줬고 그 이외의 상황에서 album 들을 뿌려줄 수 있게 함.
         이렇게 해버리면 cell의 첫번째 indexPath에는 cameraRoll 이 들어가서 indexPath가 늘어나는 상황이 발생하는데
         그 이후 album을 indexPath별로 뿌려주려할때 하나씩 밀려 가져온 album의 첫번째 album을 못 불러오는 상황이 발생함.
         cameraRoll을 가져온 이후 album을 가져올때는 indexPath.row - 1 을 해줘서 loss가 안나게 전부 가져올 수 있도록 함.
        */
        if(fetchCameraRoll.count == 0){
            return cell
        }
        switch indexPath.row {
        case 0:
            print(fetchCameraRoll.count)
            let albumCollection: PHAssetCollection = self.fetchCameraRoll.firstObject!
            self.fetchResult = PHAsset.fetchAssets(in: albumCollection, options: fetchOptions)
            let thumbnail: PHAsset = self.fetchResult.lastObject!
            self.imageManager.requestImage(for: thumbnail, targetSize: CGSize(width: self.albumSize, height: self.albumSize), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.photoImage?.image = image})
            cell.identifier = albumCollection.localIdentifier
            cell.albumNameLabel.text = "\(albumCollection.localizedTitle!)"
            cell.photoCntLabel.text = "\(fetchResult.count)"
            // image bound ;; masksToBounds 안하면 설정 안됨. 기본값이 background 랑 layer쪽에만 적용되게 되어있음
            cell.photoImage.layer.cornerRadius = 5
            cell.photoImage.layer.masksToBounds = true
            return cell
        default:
            let albumCollection: PHAssetCollection = self.fetchAlbum.object(at: indexPath.row - 1)
            
            /** Thumbnail
             fetchOption 구현
             현재 보여줄 앨범 위치를 indexPath.row 를 통해 가져와서 albumCollection에 초기화
             fetchResult에 앨범 안의 사진 초기화
             thumbnail 변수에 가져온 앨범 중 가장 마지막(처음) 사진을 초기화
             imageManager를 통해 cell에 thumbnail 뿌려주기
             */
            
            self.fetchResult = PHAsset.fetchAssets(in: albumCollection, options: fetchOptions)
//            if self.fetchResult.count > 0 {
            let thumbnail: PHAsset = self.fetchResult.lastObject!
        
            self.imageManager.requestImage(for: thumbnail, targetSize: CGSize(width: self.albumSize, height: self.albumSize), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.photoImage?.image = image})
            cell.identifier = albumCollection.localIdentifier
            cell.albumNameLabel.text = "\(albumCollection.localizedTitle!)"
            cell.photoCntLabel.text = "\(albumCollection.estimatedAssetCount)"
        
            // image bound ;; masksToBounds 안하면 설정 안됨. 기본값이 background 랑 layer쪽에만 적용되게 되어있음
            cell.photoImage.layer.cornerRadius = 5
            cell.photoImage.layer.masksToBounds = true
            return cell
            // smartAlbum fetch 했을때 앨범 내 object 가 없는경우 위에 thumnail optional 강제해제구문에서 에러가 발생해서 예외구문 작성함.
       /* } else{
            let albumCollectionThrow = self.fetchAlbum.object(at: 0)
            self.fetchResult = PHAsset.fetchAssets(in: albumCollectionThrow, options: fetchOptions)
            let thumbnailThrow = self.fetchResult.lastObject!
            self.imageManager.requestImage(for: thumbnailThrow, targetSize: CGSize(width: self.albumSize, height: self.albumSize), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in cell.photoImage?.image = image})
            cell.identifier = albumCollection.localIdentifier
            cell.albumNameLabel.text = "Error"
            cell.photoCntLabel.text = "0"
            return cell
        }*/
        }
    }
    
    // observe header & footer Cell disappear or appear
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        navigationBar.title = "Album"
//    }
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        navigationBar.title = ""
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let PhotoListVC = segue.destination as! PhotoListVC
        
        let cell: PhotoCollectionViewCell = sender as! PhotoCollectionViewCell
        PhotoListVC.identifier = cell.identifier
        PhotoListVC.albumName = cell.albumNameLabel.text
        selectedIndex = collectionView.indexPathsForSelectedItems!
    }
    
    //MARK:: 앨범 안에서 사진 삭제 후 앨범 Cnt 수정이 안됨.. 썸네일은 수정 되는데... 시불장거
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.collectionView.reloadSections(IndexSet(0...0))
        
        if (isChanged){
            print(selectedIndex)
            /*
            let cell: PhotoCollectionViewCell = collectionView.cellForItem(at: selectedIndex.first!) as! PhotoCollectionViewCell
            let albumCollection = fetchAlbum.object(at: (selectedIndex.first?.row)!)
            cell.photoCntLabel.text = "\(albumCollection.estimatedAssetCount)"
            isChanged = false
 */
        }
    }

    override func viewDidLoad() {
        photoAuthoriztion()
//        print(fetchCameraRoll.lastObject?.localizedTitle)
        // Style 에는 alert -> 기본 알람형식, actionSheet -> 아래서 나오는거 로 나눠짐.
//        let enterAlert = UIAlertController.init(title: nil, message: "Correct Password📲", preferredStyle: .actionSheet)
//        let enterIncorrect = UIAlertController.init(title: nil, message: "InCorrect Password🔐", preferredStyle: .actionSheet)
//        let alertView = UIAlertController.init(title: nil, message: "사진 좀 쓸게용🥰", preferredStyle: .alert)
//
//        let cancel = UIAlertAction.init(title: "시렁😝", style: .cancel, handler: {(_) in self.present(alertView, animated: true, completion: nil)})
//        let permit = UIAlertAction.init(title: "그랭☺️", style: .default, handler:{(_) in
//            enterText = (alertView.textFields?.first?.text)!
//            print(enterText)
//            if (enterText == "ok") {
//                self.present(enterAlert, animated: true, completion: {print("alert Again")})
//            } else{
//                self.present(enterIncorrect, animated: true, completion: {})
//            }
//        })
//        alertView.addAction(cancel)
//        alertView.addAction(permit)
//
//        let enterOk = UIAlertAction.init(title: "welcome", style: .default, handler: nil)
//        let enterNo = UIAlertAction.init(title: "Retry", style: .destructive, handler: {(_) in
//            self.present(alertView, animated: true, completion: nil)
//        })
//        enterAlert.addAction(enterOk)
//        enterIncorrect.addAction(enterNo)
//        alertView.addTextField(configurationHandler: {(field: UITextField) in
//            field.textColor = UIColor.red
//            field.placeholder = "Password🔑"
//        })
//
//        present(alertView, animated: true, completion: nil)
        
        
        
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // large font on navigationBarTitle
        navigationController?.navigationBar.prefersLargeTitles = true

        // how to bring Screen's width & height
        // UIScreen.main.bounds.--
        let flowLayout: UICollectionViewFlowLayout
        let halfWidth: CGFloat = deviceWidth / 2.0

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10) // -> 셀 간 간격 지정
        
        // 각 셀간의 최소 공간 설정
//        flowLayout.minimumInteritemSpacing = 20
//        flowLayout.minimumLineSpacing = 50
        

        // itemSize 고정
        flowLayout.itemSize = CGSize(width: halfWidth - 20 , height: halfWidth + 40)
        // itemSize 유동적으로 수정해줌 ?
//        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 20, height: halfWidth - 20)
        
        self.collectionView.collectionViewLayout = flowLayout
        navigationController?.isToolbarHidden = true
    }
    

}

