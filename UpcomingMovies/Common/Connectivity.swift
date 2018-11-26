//
//  Connectivity.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 25/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
