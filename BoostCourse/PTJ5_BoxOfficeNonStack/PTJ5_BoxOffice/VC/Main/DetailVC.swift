//
//  tableViewDetailVC.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 11/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit



class DetailVC: UIViewController,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var scrollContentView: UIView!
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieRunningtime: UILabel!
    @IBOutlet var reservationRate: UILabel!
    @IBOutlet var movieGrade: UIImageView!
    @IBOutlet var userRate: UILabel!
    @IBOutlet var userRateStar2: UIImageView!
    @IBOutlet var userRateStar4: UIImageView!
    @IBOutlet var userRateStar6: UIImageView!
    @IBOutlet var userRateStar8: UIImageView!
    @IBOutlet var userRateStar10: UIImageView!
    @IBOutlet var viewers: UILabel!
    @IBOutlet var plot: UILabel!
    @IBOutlet var director: UILabel!
    @IBOutlet var actor: UILabel!
    @IBOutlet var commentTableView: UITableView!
    
    
    var movieID: String!
    var movieDetails: MovieDetail!
    var comments: [Comment] = []
    let networkingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var requestView: UIView = UIView.init()
    var indicatorBackground: UIView = UIView.init()
    
    
    func errorLoadingAlert(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok: UIAlertAction = UIAlertAction.init(title: "확인", style: .default, handler: {(_) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    /*
     3/14 MARK:: requestDetail & requestCommnet Merge
     두개 한 구문으로 병합하려고 했는데 귀찮아서 requestDetail 호출 후 성공했다, 그러면 requestComment 호출하도록 그냥 쑤셔박음.
     requestDetail 에서도 데이터 통신 실패했을땐 catch 통해서 error Alert 띄워주고 pop 시켜서 이전 VC 로 가도록 하고 다시 호출하도록함.
     requestDetail success 후 requestCommnet 호출 하고 실패시 error Alert, 성공시 UI 모두 할당시켜주고
     networkingIndicator 정지 시키고 가림막으로 썼던 requestView.isHidden = true 시켜줘서 데이터 넘겨준거 깔끔하게 보이게 했습니당.
     ## 근데 둘이 합치기 전에는 UI 할당 시켜줄때 에러 떴는데 합치고 나니까 데이터를 못 불러오는일이 없어짐. 데이터 통신때 시간 걸려서 sleep 해줬는데
     합치고 나면 requestDetail 먼저 불러오고  requestComment 불러오고 성공하면 UI 할당 시켜주니까 데이터 가져오는 충분한 시간을 가지는듯.
    */
    func requestDetail(){
        networkingIndicator.startAnimating()
        
        let movieDetailAddress: String = detailURL + movieID
        print(movieDetailAddress)
        guard let url: URL = URL(string: movieDetailAddress) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            // 데이터 통신 성공 or 실패 여부 판단. success code = 200
            // 근데 success 아닐땐 error로 처리하니까 따로 성공했을때 확인 할 필요가 있을까 ..?
            // ( error가 아닐때 && code != 200 ) -> 응답이 없을때?
            let responseCode = response as! HTTPURLResponse
            print(responseCode.statusCode)
            
            
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
                DispatchQueue.main.async {
                    self.requestComment()
                }
            } catch(let err){
                print(err.localizedDescription)
                print("Error in Detail: \(error)")
                self.errorLoadingAlert(title: "Error", message: "Fail in Detail")
            }
        }
        dataTask.resume()
        
    }
    
    func requestComment(){
        let commentAddress: String = commentURL + movieID
        print(commentAddress)
        guard let url: URL = URL(string: commentAddress) else { return }

        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in

            let responseCode = response as! HTTPURLResponse
            print(responseCode.statusCode)
            
            
            if let error = error{
                print(error.localizedDescription)
                return
            }

            guard let data = data else {return}

            do{
                let apiResponse: CommentResponse = try JSONDecoder().decode(CommentResponse.self, from: data)
                self.comments = apiResponse.comments
                DispatchQueue.main.async {
                    self.commentTableView.reloadData()
                    self.setUI()
                    self.markStars()
                    self.requestView.isHidden = true
                    self.indicatorBackground.isHidden = true
                    self.networkingIndicator.stopAnimating()
                }
                
            } catch(let err){
                print(err.localizedDescription)
                print("Error in Comment: \(error)")
                self.errorLoadingAlert(title: "Error", message: "Fail in Comment")
            }
        }
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: commentCell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! commentCell
        let comment: Comment = comments[indexPath.row]
        
        cell.userID.text = comment.writer
        cell.comment.text = comment.contents
        cell.cosmosRateView.rating = comment.rating / 2
        
        let unixTimeStamp = comment.timestamp
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        cell.date.text = strDate
        
        return cell
    }
    
    func markStars(){
        let rate: Double = Double(userRate.text!)!
        print(rate)
        switch rate {
        case 1..<2:
            userRateStar2.image = UIImage(named: "ic_star_large_half")
        case 2..<3:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
        case 3..<4:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_half")
        case 4..<5:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
        case 5..<6:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_half")
        case 6..<7:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_full")
        case 7..<8:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_full")
            userRateStar8.image = UIImage(named: "ic_star_large_half")
        case 8..<9:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_full")
            userRateStar8.image = UIImage(named: "ic_star_large_full")
        case 9..<10:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_full")
            userRateStar8.image = UIImage(named: "ic_star_large_full")
            userRateStar10.image = UIImage(named: "ic_star_large_half")
        case 10:
            userRateStar2.image = UIImage(named: "ic_star_large_full")
            userRateStar4.image = UIImage(named: "ic_star_large_full")
            userRateStar6.image = UIImage(named: "ic_star_large_full")
            userRateStar8.image = UIImage(named: "ic_star_large_full")
            userRateStar10.image = UIImage(named: "ic_star_large_full")
        default:
            return
        }
    }
    func setUI(){
        navigationBar.title = movieDetails.title
        guard let imageURL: URL = URL(string: movieDetails.image) else { return }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
        moviePoster.image = UIImage(data: imageData)
        movieGrade.image = setGradeImage(grade: movieDetails.grade)
        movieTitle.text = movieDetails.title
        movieReleaseDate.text = movieDetails.date + "개봉"
        movieRunningtime.text = "\(movieDetails.genre)/" + "\(movieDetails.duration)분"
        plot.text = movieDetails.synopsis
        director.text = movieDetails.director
        actor.text = movieDetails.actor
        reservationRate.text = "\(movieDetails.reservation_grade)위 " + "\(movieDetails.reservation_rate)%"
        userRate.text = "\(movieDetails.user_rating)"
        viewers.text = movieDetails.audienceComma
    }
    
    // 이거 백그라운드 컬러 어떻게 지정하냐 진짜 찾아봐도 안나오네.;
    // 그냥 뷰 하나 더 만들어서 크기 작게해서 networkingIndicator 랑 위치 맞춰버림.
    func indicatorUI(){
        networkingIndicator.center = self.view.center
        networkingIndicator.center.y = UIScreen.main.bounds.height / 2 - 50
        networkingIndicator.hidesWhenStopped = true
        networkingIndicator.style = .whiteLarge
        
        indicatorBackground.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        indicatorBackground.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        indicatorBackground.clipsToBounds = true
        indicatorBackground.layer.cornerRadius = 10
        indicatorBackground.center = networkingIndicator.center
        
        requestView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        requestView.backgroundColor = UIColor.white
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC: CommentVC = segue.destination as! CommentVC
        nextVC.mtitle = movieTitle.text
        nextVC.grade = movieGrade.image
        nextVC.movieID = movieID
        print(movieTitle.text)
    }
    override func viewDidLoad() {
        /*
         데이터 통신 할 동안 UI를 할당 못해주니까 화면에 스토리보드에 올려놓은 label 이나 imageView가 default 상태 그대로 보이는게 꼴보기 싫어서
         그냥 쌩 하얀색 view 하나 만들어서 screen size 만큼 뿌려줘서 안보이게 가리고 networkingIndicator(ActivityIndicator) 올려놔서
         데이터 불러오는중임을 표시해준다. -> indicatorUI()
        */
        
        indicatorBackground.isHidden = false
        requestView.isHidden = false
        indicatorUI()
        self.view.addSubview(requestView)
        requestView.addSubview(indicatorBackground)
        requestView.addSubview(networkingIndicator)
        
        self.scrollView.delegate = self
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.commentTableView.dataSource = self
        self.commentTableView.delegate = self
        self.requestDetail()
        commentTableView.isScrollEnabled = false
        commentTableView.allowsSelection = false

        /*
         3/13 MARK:: 이거 응답 요청할때 process 돌아가는거 user 한테 indicate 해줘야 하는데 그걸 빼먹은거같음.
                    근데 알려줘도 요청에 실패하면 재시도를 하던가 뭐 그렇게 해서 setUI를 불러줘야할건데 request 쟤네 구문이 아예
                    백그라운드에서 동작해서 뒤로 보내버리고 바로 setUI 부르는거같은데 이걸 sleep 으로 계속 해결해야하나...?
         3/14 해결
        */

    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(indicatorBackground)
        self.view.addSubview(networkingIndicator)
        networkingIndicator.startAnimating()
        indicatorBackground.isHidden = false
        
        requestComment()
    }
}
