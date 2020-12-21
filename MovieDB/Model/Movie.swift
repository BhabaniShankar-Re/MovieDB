//
//  Movie.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import UIKit

struct Movie: Decodable, Equatable {
    let title: String
    let overview: String
    let language: String
    let rating: Float
    let popularity: Float
    let posterUrl: String
    let genres: [Int]
    let releaseDate: String
    
    var posterImage: UIImage?
    var thumbnailImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case title, overview, popularity
        case language = "original_language"
        case rating = "vote_average"
        case posterUrl = "poster_path"
        case genres = "genre_ids"
        case releaseDate = "release_date"
    }
}


struct RequestModel: Decodable {
    let page: Int
    let movieList: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movieList = "results"
    }
    
}

struct MovieGenre: Decodable {
    let id: Int
    let name: String
}
