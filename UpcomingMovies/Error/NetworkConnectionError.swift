//
//  NetworkConnectionError.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 25/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

class NetworkConnectionError: Error {
    var message: String?
    
    init() {
        
    }
    
    init(message: String) {
        self.message = message
    }
}
