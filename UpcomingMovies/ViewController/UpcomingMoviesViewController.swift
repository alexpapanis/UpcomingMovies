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
//    private let filteredUpcomingMovies = UpcomingMoviesViewModel
    var searching: Bool!
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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

extension UpcomingMoviesViewController:  UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        if searchText.isEmpty {
            searching = false
//            filteredUpcomingMovies = upcomingMoviesViewModel
        } else {
//            filteredUpcomingMovies = movies.filter({(dataString: Palestrante) -> Bool in
//                // If dataItem matches the searchText, return true to include it
//                searching = true
//                return dataString.nome?.folding(options: .diacriticInsensitive, locale: .current).range(of: searchText.folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive) != nil
//            })
        }
        
        
        tableView.reloadData()
        
    }
}
