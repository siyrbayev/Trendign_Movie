//
//  MovieDetailsEntity.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 16.05.2021.
//

import Foundation

struct MovieDetailsEntity: Decodable {
    var id: Int?
    let backdrop: String?
    let poster: String?
    let title: String?
    let releaseDate: String?
    let rating: Double?
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case overview = "overview"
    }
}
