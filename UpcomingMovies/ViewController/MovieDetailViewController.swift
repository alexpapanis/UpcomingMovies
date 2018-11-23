//
//  MovieDetailViewController.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 22/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieDetailViewController: UIViewController {

    //MARK: Variables
    private let disposeBag = DisposeBag()
    
    //MARK: Outlets
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var posterImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var overviewHeightConstraint: NSLayoutConstraint!
    
    var movieViewModel: MovieViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movieViewModel?.title
        ratingLabel.text = movieViewModel?.rating
        releaseDateLabel.text = "Release date: \(movieViewModel?.releaseDate ?? "TBA")"
        categoriesLabel.text = movieViewModel?.categories
        overviewTextView.text = movieViewModel?.overview
        overviewTextView.sizeToFit()
        posterImageButton.sd_setImage(with: URL(string: (movieViewModel?.posterPath)!), for: .normal, completed: nil)
        
        self.backdropImageView.lock(duration: 0)
        self.backdropImageView.image = nil
        movieViewModel?.backdropLocalPathObservable.subscribe(onNext: { backdropLocalPath in
            guard let backdropLocalPath = backdropLocalPath else { return }
            
            do {
                let url = URL(fileURLWithPath: backdropLocalPath)
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                self.backdropImageView.image = image
            } catch {
                self.backdropImageView.image = UIImage(named: "movieNegative")
                print(error)
            }
            self.backdropImageView.unlock()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        overviewHeightConstraint.constant = overviewTextView.contentSize.height
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto", let vc = segue.destination as? ViewPhotoViewController {
            if let photo = sender as? UIImage {
                vc.image = photo
            }
        }
    }

    @IBAction func showPhoto(_ sender: UIButton) {
        performSegue(withIdentifier: "showPhoto", sender: sender.imageView?.image)
    }
}
