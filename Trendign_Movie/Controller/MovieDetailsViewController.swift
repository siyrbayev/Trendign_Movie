//
//  MovieDetailsViewController.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 22.04.2021.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetailsViewController: UIViewController {
    public static var idetifier = "MovieDetailsViewController"
    public static var nib = UINib(nibName: idetifier, bundle: Bundle(for: MovieDetailsViewController.self))
    
    private var movieId: Int = 0
    private var MOVIE_URL: String = ""
    
    private var movie: MovieEntity.Movie?{
        didSet{
            if let movie = movie {
                let movieBackdropURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie.backdrop ?? ""))
                ratingLabel.text = String(movie.rating)
                releaseDateLabel.text = movie.releaseDate
                moviewTitleLabel.text = movie.title
                movieBackdropImageView.kf.setImage(with: movieBackdropURL)
                self.navigationItem.title = moviewTitleLabel.text
                movieOverviewLabel.text = movie.overview
            }
        }
    }
    
    @IBOutlet weak var releaseDateView: UIView!
    @IBOutlet weak private var movieBackdropImageView: UIImageView!
    @IBOutlet weak var layersStackView: UIStackView!
    @IBOutlet weak private var ratingLabel: UILabel!
    @IBOutlet weak private var moviewTitleLabel: UILabel!
    @IBOutlet weak private var releaseDateLabel: UILabel!
    @IBOutlet weak private var movieOverviewLabel: UILabel!
    @IBOutlet weak var overviewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieById(movieId)
        configureLayout()
    }
}

extension MovieDetailsViewController{
    public func configure(movieId id: Int){
        movieId = id
        MOVIE_URL = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=00133da9de6d883e708e1c2aee13de35&language=en-US"
    }
    
    private func configureLayout(){
        self.navigationItem.backBarButtonItem?.title = "Back"
        releaseDateView.layer.cornerRadius = releaseDateView.bounds.width / 2
    }
        
    private func getMovieById(_ movieId: Int) {
        AF.request(MOVIE_URL, method: .get, parameters: [:]).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let movieJSON = try JSONDecoder().decode(MovieEntity.Movie.self, from: data)
                        self.movie = movieJSON
                    } catch let JSONErr {
                        print(JSONErr)
                    }
                }
            case.failure:
                print("MOVIE_URL failed to retrieve Data")
            }
        }
    }
}
