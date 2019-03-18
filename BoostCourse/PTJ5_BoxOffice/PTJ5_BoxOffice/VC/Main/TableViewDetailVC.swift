//
//  tableViewDetailVC.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 11/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

let detailURL: String = "https://connect-boxoffice.run.goorm.io/movie?id="

class TableViewDetailVC: UIViewController,UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieRunningtime: UILabel!
    

    var movieID: String!
    var movieDetails: MovieDetail!
    
    func requestDetail(){
        let movieDetailAddress: String = detailURL + movieID
        print(movieDetailAddress)
        guard let url: URL = URL(string: movieDetailAddress) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            
            do{
                // Decode 할때는 JSON파일 형태 잘 살펴보고 decode해줘야지 에러 안나욧!
                // 형식이 구조체 형식인지, 단일 형식인지 잘 보고 해야댐. -> VO 파일 참조, 비교
                let apiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                self.movieDetails = apiResponse
            } catch(let err){
                print(err.localizedDescription)
                print("Error: \(error)")
            }
        }
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        self.scrollView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        requestDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        print(movieDetails)
        guard let imageURL: URL = URL(string: movieDetails.image) else { return }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
        moviePoster.image = UIImage(data: imageData)
        movieTitle.text = movieDetails.title
        movieReleaseDate.text = movieDetails.date + "개봉"
        movieRunningtime.text = "\(movieDetails.genre)/" + "\(movieDetails.duration)분"
    }
}
