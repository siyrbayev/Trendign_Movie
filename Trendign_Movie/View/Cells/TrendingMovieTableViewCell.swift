//
//  TrendingMovieTableViewCell.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 20.04.2021.
//

import UIKit
import Kingfisher

class TrendingMovieTableViewCell: UITableViewCell {
    public static let identifier: String = "TrendingMovieTableViewCell"
    public static let nib = UINib(nibName: identifier, bundle: Bundle(for: TrendingMovieTableViewCell.self))

    public var reloadTableViewCallBack: (() -> Void) = { print("Nothong")}
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet private var ratingContainerView: UIView!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var movieTitleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet var layersStackView: UIStackView!
    @IBOutlet var favoriteButton: UIButton!
    
    public var movie: TrendingMovieEntity.Movie?{
        didSet {
            if let movie = movie {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster ?? ""))
                posterImageView.kf.setImage(with: posterURL)
                ratingLabel.text = String(movie.rating ?? 0)
                movieTitleLabel.text = movie.title
                releaseDateLabel.text = movie.releaseDate
                
                if let _ = MovieEntityCoreDataManager.shared.findMovie(with: movie.id){
                    favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                } else {
                    favoriteButton.setImage(UIImage(named: "star"), for: .normal)
                }
            }
        }
    }
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let movie = movie {
            if let _ = MovieEntityCoreDataManager.shared.findMovie(with: movie.id){
                MovieEntityCoreDataManager.shared.deleteMovie(with: movie.id)
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            } else {
                MovieEntityCoreDataManager.shared.addMovie(movie)
                favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
            }
        }
        reloadTableViewCallBack()
    }
}

extension TrendingMovieTableViewCell {
    
    private func configureLayout() {
        selectionStyle = .none
        
        posterImageView.backgroundColor = .systemGray5
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
        
        ratingContainerView.layer.cornerRadius = ratingContainerView.bounds.width / 2
        ratingContainerView.layer.masksToBounds = true
    }

}
