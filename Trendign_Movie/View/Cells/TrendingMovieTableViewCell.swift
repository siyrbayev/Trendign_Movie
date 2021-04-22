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
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak private var ratingContainerView: UIView!
    @IBOutlet weak private var ratingLabel: UILabel!
    @IBOutlet weak private var movieTitleLabel: UILabel!
    @IBOutlet weak private var releaseDateLabel: UILabel!
    @IBOutlet weak var layersStackView: UIStackView!
    
    private var movie: MovieEntity.Movie?{
        didSet {
            if let movie = movie {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster ?? ""))
                posterImageView.kf.setImage(with: posterURL)
                ratingLabel.text = String(movie.rating)
                movieTitleLabel.text = movie.title
                releaseDateLabel.text = movie.releaseDate
            }
        }
    }
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        selectionStyle = .none
        posterImageView.backgroundColor = .systemGray5
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
        ratingContainerView.layer.cornerRadius = ratingContainerView.bounds.width / 2
        ratingContainerView.layer.masksToBounds = true
    }
    
    public func configure(movie: MovieEntity.Movie){
        self.movie = movie
    }

}
