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
    
    private var movieId: Int?
    private var MOVIE_URL: String?
    private var movieDetails: MovieDetailsEntity?
    public var reloadRowCallBack: (() -> Void) = {print("No callback funciton")}
    
    @IBOutlet weak private var releaseDateView: UIView!
    @IBOutlet weak private var movieBackdropImageView: UIImageView!
    @IBOutlet weak private var layersStackView: UIStackView!
    @IBOutlet weak private var ratingLabel: UILabel!
    @IBOutlet weak private var moviewTitleLabel: UILabel!
    @IBOutlet weak private var releaseDateLabel: UILabel!
    @IBOutlet weak private var movieOverviewTextView: UITextView!
    @IBOutlet weak private var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = movieId else {
            return
        }
        getMovieById(id)
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let movieId = movieId{
            if let _ = MovieEntityCoreDataManager.shared.findMovie(with: movieId){
                favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        defer {
            reloadRowCallBack()
        }
        if let movieId = movieId{
            if let _ = MovieEntityCoreDataManager.shared.findMovie(with: movieId){
                MovieEntityCoreDataManager.shared.deleteMovie(with: movieId)
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            } else {
                if var details = movieDetails {
                    details.id = movieId
                    MovieEntityCoreDataManager.shared.addMovie(details)
                    favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                }
                
            }
        }
    }
    
}

extension MovieDetailsViewController{
    public func configure(movieId id: Int){
        movieId = id
        MOVIE_URL = "https://api.themoviedb.org/3/movie/\( String(describing: id)))?api_key=00133da9de6d883e708e1c2aee13de35&language=en-US"
    }
    
    private func configureLayout(){
        self.navigationItem.backBarButtonItem?.title = "Back"
        releaseDateView.layer.cornerRadius = releaseDateView.bounds.width / 2
        movieOverviewTextView.showsVerticalScrollIndicator = false
    }
        
    private func getMovieById(_ movieId: Int) {
        AF.request(MOVIE_URL!, method: .get, parameters: [:]).responseJSON { [weak self] (response) in
            
            switch response.result {
            case .success:
                    do {
                        guard let data = response.data else{return}
                        self?.movieDetails = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
                        self?.updateUI(self?.movieDetails)
                    } catch let JSONErr {
                        print(JSONErr)
                    }
            case.failure:
                print("MOVIE_URL failed to retrieve Data")
            }
        }
    }
    
    private func updateUI(_ details: MovieDetailsEntity?){
        if let details = details {
            let movieBackdropURL = URL(string: "https://image.tmdb.org/t/p/w500" + (details.backdrop ?? ""))
            ratingLabel.text = String(details.rating ?? 0.0)
            
            releaseDateLabel.text = details.releaseDate
            
            moviewTitleLabel.text = details.title
            
            movieBackdropImageView.kf.setImage(with: movieBackdropURL)
            
            self.navigationItem.title = moviewTitleLabel.text
            
            movieOverviewTextView.text = details.overview
        }
    }
}
