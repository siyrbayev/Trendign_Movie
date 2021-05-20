//
//  ViewController.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 20.04.2021.
//

import UIKit
import Alamofire

class TrendingMoviesViewController: UIViewController {
    
    private let TRENDING_MOVIES_URL = "https://api.themoviedb.org/3/trending/movie/week?api_key=00133da9de6d883e708e1c2aee13de35"

    @IBOutlet weak var trendingTableView: UITableView!
    
    
    private var pageNumber: Int = 1
    
    private var movies: [TrendingMovieEntity.Movie] = [TrendingMovieEntity.Movie]() {
        didSet{
            trendingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTrendingTableView()
        getTrendingMovies(pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trendingTableView.reloadData()
    }
    
    func configTrendingTableView() {
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        trendingTableView.register(TrendingMovieTableViewCell.nib, forCellReuseIdentifier: TrendingMovieTableViewCell.identifier)
        trendingTableView.showsVerticalScrollIndicator = false
    }

    

}
// MARK - Internal Func
extension TrendingMoviesViewController {
    private func getTrendingMovies(_ page: Int? = nil){
        var params: [String: Any] = [:]
        if let page = page {
            params["page"] = page
        }
        
        AF.request(TRENDING_MOVIES_URL, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let movieJSON = try JSONDecoder().decode(TrendingMovieEntity.self, from: data)
                        self.movies += movieJSON.results
                    } catch let JSONErr {
                        print(JSONErr)
                    }
                }
            case .failure:
                print("TRENDING_MOVIES_URL failed to retrieve Data")
                }
            }
        }
    }


// MARK - UITableViewDelegate
extension TrendingMoviesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.idetifier) as! MovieDetailsViewController
        vc.configure(movieId: movies[indexPath.row].id)
        vc.reloadRowCallBack = {
            self.trendingTableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        pageNumber += 1
        
        if deltaOffset <= 10 && currentOffset > 100 {
            getTrendingMovies(pageNumber)
        }
        
    }
}

// MARK - UITableViewDataSource
extension TrendingMoviesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendingMovieTableViewCell.identifier, for: indexPath) as! TrendingMovieTableViewCell
        
        cell.movie = movies[indexPath.row]
        cell.reloadTableViewCallBack = {
            self.trendingTableView.reloadData()
        }
        
        return cell
    }
}
