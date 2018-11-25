//
//  APIRouter.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation
import Alamofire

class APIRouter {
    static func getUpcomingMovies(page: Int) -> URLRequestConvertible {
        
        
        var urlComponents = URLComponents(string: K.ProductionServer.baseURL + K.ProductionServer.upcomingMovies)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: K.APIParameterKey.key),
            URLQueryItem(name: "language", value: K.APIParameterKey.language),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        //request.httpBody = try JSONSerialization.data(withJSONObject: parametros, options: .prettyPrinted)
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request as URLRequestConvertible
    }
    
    static func getMovies(by name: String, page: Int) -> URLRequestConvertible {
        
        
        var urlComponents = URLComponents(string: K.ProductionServer.baseURL + K.ProductionServer.searchMovies)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: K.APIParameterKey.key),
            URLQueryItem(name: "language", value: K.APIParameterKey.language),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "query", value: "\(name)")
        ]
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        //request.httpBody = try JSONSerialization.data(withJSONObject: parametros, options: .prettyPrinted)
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request as URLRequestConvertible
    }
    
}
