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
    private let gradientLayer = CAGradientLayer()
    private let disposeBag = DisposeBag()
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var movieViewModel: MovieViewModel! {
        didSet {
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : UIColor.black,
                .foregroundColor : UIColor.white,
                .strokeWidth : -2.0,
                ]
            
            titleLabel.attributedText = NSAttributedString(string: movieViewModel.title, attributes: strokeTextAttributes)
            releaseDateLabel.attributedText = NSAttributedString(string: movieViewModel.releaseDate, attributes: strokeTextAttributes)
            categoryLabel.attributedText = NSAttributedString(string: movieViewModel.categories, attributes: strokeTextAttributes)
            
            //titleLabel.text = movieViewModel.title
            //categoryAndReleaseDateLabel.text = movieViewModel.releaseDate + " - " + movieViewModel.categories
            self.backDropImageView.lock(duration: 0)
            self.backDropImageView.image = nil
            movieViewModel.backdropLocalPathObservable.subscribe(onNext: { backdropLocalPath in
                guard let backdropLocalPath = backdropLocalPath else { return }
                
                do {
                    let url = URL(fileURLWithPath: backdropLocalPath)
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    self.backDropImageView.image = image
                } catch {
                    self.backDropImageView.image = UIImage(named: "movieNegative")
                    print(error)
                }
                self.backDropImageView.unlock()
            }).disposed(by: disposeBag)
        }
    }
}
