//
//  MovieEntity.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 20.04.2021.
//

import Foundation

struct MovieEntity: Decodable {
    let results: [Movie]
    
    struct Movie: Decodable {
        let id: Int
        let poster: String?
        let backdrop: String?
        let title: String
        let releaseDate: String
        let rating: Double
        let overview: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case poster = "poster_path"
            case title = "title"
            case releaseDate = "release_date"
            case rating = "vote_average"
            case backdrop = "backdrop_path"
            case overview = "overview"
        }
    }
    
    
}
