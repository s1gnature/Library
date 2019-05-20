//
//  ViewController.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 08/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit



class TableVC: UIViewController, UITableViewDataSource {
    
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    
    var movies: [Movie] = []
    var refreshControll = UIRefreshControl()
    
    
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
//                    self.tableView.reloadData()
                    self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
                }
                
            } catch(let err){
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: tableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! tableViewCell
        
        let movie: Movie = movies[indexPath.row]
        
        cell.Poster.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 20, height: cell.Poster.frame.height)
        cell.Poster.image = UIImage(named: "img_placeholder")
        cell.movieTitle.text = movie.title
        cell.movieDescription.text = movie.descriptionForTable
        cell.movieRealeaseDate.text = movie.date
        cell.gradeImage.image = setGradeImage(grade: movie.grade)
        
        guard let imageURL: URL = URL(string: movie.thumb) else { return cell }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        cell.Poster.image = UIImage(data: imageData)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailVC = segue.destination as! DetailVC
        let indexPath = tableView.indexPathForSelectedRow
        print(movies[(indexPath?.row)!].title)
        let currentMovie = movies[(indexPath?.row)!]
        detailVC.movieID = currentMovie.id
    }
    @objc func refresh(_ sender: Any) {
        tableView.reloadData()
        if refreshControll.isRefreshing
        {
            refreshControll.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestMovieList(type: requestType)
        navigationBar.title = changeTitle(requestType: requestType)
    }
    
    
    override func viewDidLoad() {
        //MARK:: Pull to Refresh 하는 법
        refreshControll.attributedTitle = NSAttributedString(string: "새로고침 중 입니다🥰")
        refreshControll.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControll)
        
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableView.dataSource = self
        self.tableView.rowHeight = UIScreen.main.bounds.height / 8
        // Do any additional setup after loading the view, typically from a nib.
    }


}

