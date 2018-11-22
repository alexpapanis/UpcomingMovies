//
//  MovieViewModel.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    //MARK: Variables
    private let movie: Movie
    private var backdropLocalPath = BehaviorRelay<String?>(value: nil)
    
    
    //MARK: - RXObservable
    var backdropLocalPathObservable: Observable<String?> {
        return backdropLocalPath.asObservable()
    }
    
    //MARK: - Init
    init(_ movie: Movie) {
        self.movie = movie
        
        loadBackdrop()
    }
    
    //MARK: - Load backdrop image
    private func loadBackdrop() {
        guard let url = movie.backdropPath else {
            self.backdropLocalPath.accept("")
            return
        }
        
        let name = url.replacingOccurrences(of: "/", with: "_")
        
        var filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        filePath = filePath.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            self.backdropLocalPath.accept(filePath.relativePath)
        } else {
            APIClient.dataFrom(url: url) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        try data.write(to: filePath, options: .atomic)
                        self?.backdropLocalPath.accept(filePath.path)
                    } catch {
                        print("Unable to write data: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Movie properties
    var title: String {
        return movie.title
    }
    
    var releaseDate: String {
        return movie.releaseDate 
    }
    
    var categories: String {
        var categories: String = ""
        
        for category in movie.genre {
            categories = (categories == "") ? Genre.getGenreBy(id: category)
                : categories + " / " + Genre.getGenreBy(id: category)
        }
        
        return categories
    }
}
