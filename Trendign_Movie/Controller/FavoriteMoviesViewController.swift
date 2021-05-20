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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !movieEntityCoreDataManager.allMovies().isEmpty {
            movies = movieEntityCoreDataManager.allMovies()
        }
    }
    
}

// MARK - Internal Func
extension FavoriteMoviesViewController {
    private func configureFavoriteTableView(){
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(TrendingMovieTableViewCell.nib, forCellReuseIdentifier: TrendingMovieTableViewCell.identifier)
        favoriteTableView.showsVerticalScrollIndicator = false
        favoriteTableView.separatorStyle = .none
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20)
        messageLabel.tintColor = .darkGray
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

// MARK - UITableViewDataSource
extension FavoriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
                self.favoriteTableView.setEmptyMessage("Favorite movies is empty")
            } else {
                self.favoriteTableView.restore()
            }
        return movies.count
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
