//
//  APIClient.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

import Alamofire

class APIClient {
    //MARK: getUpcomingMovies request
    static func getUpcomingMovies(page: Int, completion:@escaping (Result<[Movie]>)->Void) {
        
        Alamofire.request(APIRouter.getUpcomingMovies(page: page))
            .responseJSON() { response in
                guard let data = response.value as? [String: Any] else { return }
                guard let results = data["results"] else { return }
                guard response.result.isSuccess else { return }
                
                var movies: [Movie]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let dataJS = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    movies = try jsonDecoder.decode([Movie].self, from: dataJS!)
                }
                catch {
                    let result = Result<[Movie]>.failure(error)
                    completion(result)
                    return
                }
                
                let result = Result<[Movie]>.success(movies)
                completion(result)
        }
    }
    
    //MARK: searchMovies by name request
    static func searchMovies(by name: String, completion:@escaping (Result<[Movie]>)->Void) {
        
        Alamofire.request(APIRouter.getMovies(by: name))
            .responseJSON() { response in
                guard let data = response.value as? [String: Any] else { return }
                guard let results = data["results"] else { return }
                guard response.result.isSuccess else { return }
                
                var movies: [Movie]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let dataJS = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    movies = try jsonDecoder.decode([Movie].self, from: dataJS!)
                }
                catch {
                    let result = Result<[Movie]>.failure(error)
                    completion(result)
                    return
                }
                
                let result = Result<[Movie]>.success(movies)
                completion(result)
        }
    }
    
    //MARK: - Receive data from url
    static func dataFrom(url: String, completion:@escaping (Result<Data>)->Void) {
        Alamofire.request("\(K.ProductionServer.baseImageURL)\(url)")
            .responseData { dataResponse in
                guard let data = dataResponse.data else {
                    let result = Result<Data>.failure(K.ServiceError.failedToParse("\(String(describing: dataResponse.request?.url)) do not have data"))
                    completion(result)
                    return
                }
                
                let result = Result<Data>.success(data)
                completion(result)
        }
    }
}
