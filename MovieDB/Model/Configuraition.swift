//
//  Configuraition.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import Foundation

struct Configuraition: Decodable {
    static var genres: [MovieGenre] = []
    let imageConfig: ConfigDetails
    
    static func genreName(of id: Int) -> String? {
        for genre in genres {
            if id == genre.id {
                return genre.name
            }
        }
        return nil
    }
    
    static func genreNames(of ids: [Int]) -> String {
        var findGenres = genres.reduce("") { (result, genre) -> String in
            if ids.contains(genre.id) {
                return (result + "\(genre.name), ")
            }else { return result }
        }
        if findGenres.isEmpty {
            return ""
        }else {
            findGenres.removeLast(2)
            return findGenres
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case imageConfig = "images"
    }
    
    struct ConfigDetails: Decodable {
        let imagesBaseUrl: String
        let thumbnailSizes: [String]
        let posterSizes: [String]
        
        enum CodingKeys: String, CodingKey {
            case imagesBaseUrl = "secure_base_url"
            case thumbnailSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
        }
    }
}
