//
//  ViewController.swift
//  PTJ4_Album
//
//  Created by mong on 09/02/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver {

    
    @IBOutlet var tableView: UITableView!
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
//    let cellIdentifier: String = "cell"
    
    @IBAction func touchUpRefreshButton(_ sender: Any) {
        self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else{ return}
        
        fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    func requestCollection(){
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else{
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoAuthorizationbStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationbStatus {
        case .authorized:
            print("Access")
            self.requestCollection()
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }

            
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not Response")
            PHPhotoLibrary.requestAuthorization({   (status) in
                switch status{
                case .authorized:
                    print("User Access")
                    self.requestCollection()
                case .denied:
                    print("User Denied")
                default: break
                }
            })
        case .restricted:
            print("Access Restricted")
        default:
            break
        }
        
        PHPhotoLibrary.shared().register(self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // UITalbeviewDelegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let asset: PHAsset = self.fetchResult[indexPath.row]

//             스와이프 후 사진 딜리트 했을때 삭제 시킬꺼냐고(performChange) 묻는 Alert 발생
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: nil)
        }
    }
    
    /// ios11 부터 좌 우 스와이프 할때 행동을 아래 구문으로 추가 가능.
    /*
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in

            
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.endUpdates()
            
        completion(true)
        }
        
        delete.backgroundColor = UIColor.orange
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        delete.backgroundColor = UIColor.orange
        return UISwipeActionsConfiguration(actions: [delete])
    }
    */
    
    // UITableviewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.imageView?.image = image
        })
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageZoomViewController = segue.destination as? ImageZoomViewController else{ return}
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else { return}
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return}
        
        nextViewController.asset = self.fetchResult[index.row]
    }
}

