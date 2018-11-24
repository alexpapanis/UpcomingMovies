//
//  Constants.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

//MARK: Server Constants
struct K {
    struct ProductionServer {
        static let baseURL = "https://api.themoviedb.org/3"
        static let language = "en-US"
        static let baseImageURL = "https://image.tmdb.org/t/p/w780"
        
        static let upcomingMovies = "/movie/upcoming"
        static let searchMovies = "/search/movie"
    }
    
    struct APIParameterKey {
        static let key = "1f54bd990f1cdfb230adb312546d765d"
        static let language = "en-US"
    }
    
    enum ServiceError : Error {
        case failedToParse(String)
    }
}

//MARK: - HTTP Constants
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

