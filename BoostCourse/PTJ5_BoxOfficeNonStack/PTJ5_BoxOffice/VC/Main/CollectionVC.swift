//
//  CollectionVC.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 08/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC: UIViewController, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationItem!
    
    var movies: [Movie] = []
    
    @IBAction func sortBtn(_ sender: Any) {
        let alert: UIAlertController = UIAlertController.init(title: "", message: "어떤 방법으로 정렬할까요?", preferredStyle: .actionSheet)
        let rate = UIAlertAction.init(title: "예매율", style: .default, handler: {(_) in
            requestType = 0
            self.requestMovieList(type: requestType)
            self.navigationBar.title = "예매율순"
        })
        let curation = UIAlertAction.init(title: "큐레이션", style: .default, handler: {(_) in
            requestType = 1
            self.requestMovieList(type: requestType)
            self.navigationBar.title = "큐레이션"
        })
        let releaseDate = UIAlertAction.init(title: "개봉일", style: .default, handler: {(_) in
            requestType = 2
            self.requestMovieList(type: requestType)
            self.navigationBar.title = "개봉일순"
        })
        let cancel = UIAlertAction.init(title: "취소", style: .cancel, handler: nil)
        alert.addAction(rate)
        alert.addAction(curation)
        alert.addAction(releaseDate)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! collectionViewCell
        
        let movie: Movie = movies[indexPath.row]
        
        cell.poster.image = UIImage(named: "img_placeholder")
        cell.movieTitle.text = movie.title
        cell.movieDescription.text = movie.descriptionForCollection
        cell.releaseDate.text = movie.date
        cell.movieGrade.image = setGradeImage(grade: movie.grade)
        
        guard let imageURL: URL = URL(string: movie.thumb) else { return cell }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        cell.poster.image = UIImage(data: imageData)
        
        return cell
    }
    
    func requestMovieList(type: Int){
        let listType: String = baseURL + "\(type)"
        print(listType)
        guard let url: URL = URL(string: listType) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            
            do{
                
                let apiResponse: APIResonse = try JSONDecoder().decode(APIResonse.self, from: data)
                self.movies = apiResponse.movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch(let err){
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailVC = segue.destination as! DetailVC
        let indexPath = collectionView.indexPathsForSelectedItems
        print(movies[(indexPath?.first?.first)!].title)
        let currentMovie = movies[(indexPath?.first?.first)!]
        detailVC.movieID = currentMovie.id
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestMovieList(type: requestType)
        navigationBar.title = changeTitle(requestType: requestType)
    }
    
    override func viewDidLoad() {
        self.collectionView.dataSource = self
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        let cellWidth = UIScreen.main.bounds.width / 2 - 20
        let cellHeight = UIScreen.main.bounds.height / 2 - 30
        
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.collectionView.collectionViewLayout = flowLayout
    }
}
