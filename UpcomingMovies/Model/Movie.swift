//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct Movie: Codable, CustomStringConvertible {
    //MARK: Variables
    let id: Int
    let title: String
    var overview: String?
    var coverPath: String?
    var genre: [Int]
    let releaseDate: String
    var backdropPath: String?
    
    //MARK: - Codable codingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genre = "genre_ids"
        case coverPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
    
    //MARK: - CustomString description
    var description: String {
        return "\(title)"
    }
}
