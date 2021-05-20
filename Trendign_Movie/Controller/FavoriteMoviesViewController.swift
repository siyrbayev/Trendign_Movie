//
//  FavoriteMoviesViewController.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 16.05.2021.
//

import UIKit


class FavoriteMoviesViewController: UIViewController {
    static let identifier = "FavoriteMoviesViewController"
    static let nib = UINib(nibName: identifier, bundle: Bundle(for: FavoriteMoviesViewController.self))
    
    private var movies: [TrendingMovieEntity.Movie] = [] {
        didSet (oldMovies) {
            if movies.count != oldMovies.count {
                favoriteTableView.reloadData()
            }
            
        }
    }
    
    final let movieEntityCoreDataManager = MovieEntityCoreDataManager.shared
    
    @IBOutlet weak private var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavoriteTableView()
        movies = movieEntityCoreDataManager.allMovies()
    }
}

// MARK - Internal Func
extension FavoriteMoviesViewController {
    private func configureFavoriteTableView(){
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(TrendingMovieTableViewCell.nib, forCellReuseIdentifier: TrendingMovieTableViewCell.identifier)
        favoriteTableView.showsVerticalScrollIndicator = false
    }
}

// MARK - UITableViewDataSource
extension FavoriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: TrendingMovieTableViewCell.identifier, for: indexPath) as! TrendingMovieTableViewCell
        cell.movie = movies[indexPath.row]
        cell.reloadTableViewCallBack = {
            self.movies = self.movieEntityCoreDataManager.allMovies()
            self.favoriteTableView.reloadData()
        }
        
        return cell;
    }
    
}

// MARK - UITableViewDelegate
extension FavoriteMoviesViewController: UITableViewDelegate {
   
}
