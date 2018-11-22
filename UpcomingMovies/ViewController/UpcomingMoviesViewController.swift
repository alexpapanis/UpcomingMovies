//
//  UpcomingMoviesViewController.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift

class UpcomingMoviesViewController: UIViewController {

    //MARK: Variables
    private let disposeBag = DisposeBag()
    private let upcomingMoviesViewModel = UpcomingMoviesViewModel()
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        setupTopMoviesViewModelObserver()
    }
    
    //MARK: - Rx Setup
    private func setupTopMoviesViewModelObserver() {
        upcomingMoviesViewModel.moviesObservable
            .subscribe(onNext: { movies in
                self.tableView.reloadData()
                print(movies)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDataSource extension
extension UpcomingMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMoviesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        cell.movieViewModel = upcomingMoviesViewModel[indexPath.row]
        
        return cell
    }
}
