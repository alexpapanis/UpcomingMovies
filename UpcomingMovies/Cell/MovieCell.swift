//
//  MovieCell.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift

class MovieCell: UITableViewCell {

    //MARK: Cell identifier
    static let identifier = "movieCell"
    
    //MARK: - Variables
    private let disposeBag = DisposeBag()
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var backdropImageViewHeight: NSLayoutConstraint!
    
    var movieViewModel: MovieViewModel! {
        didSet {
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : UIColor.black,
                .foregroundColor : UIColor.yellow,
                .strokeWidth : -2.0,
                ]
            
            titleLabel.attributedText = NSAttributedString(string: movieViewModel.title, attributes: strokeTextAttributes)
            releaseDateLabel.attributedText = NSAttributedString(string: "Release date: " + movieViewModel.releaseDate, attributes: strokeTextAttributes)
            categoryLabel.attributedText = NSAttributedString(string: movieViewModel.categories, attributes: strokeTextAttributes)
            
            self.backdropImageView.lock(duration: 0)
            self.backdropImageView.image = nil
            movieViewModel.backdropLocalPathObservable.subscribe(onNext: { backdropLocalPath in
                guard let backdropLocalPath = backdropLocalPath else { return }
                
                do {
                    let url = URL(fileURLWithPath: backdropLocalPath)
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    self.backdropImageView.image = image
                } catch {
                    self.backdropImageView.image = UIImage(named: "no-image")
                    print(error)
                }
                self.backdropImageView.unlock()
            }).disposed(by: disposeBag)
            
            let widthDevide = UIScreen.main.bounds.width
            backdropImageViewHeight.constant = widthDevide * 5 / 9
        }
    }
}
