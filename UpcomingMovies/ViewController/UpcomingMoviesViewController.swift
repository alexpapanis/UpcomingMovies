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
    private var lastContentOffset: CGFloat = 0
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail"{
            if let vc = segue.destination as? MovieDetailViewController {
                if let movieModelView = sender as? MovieViewModel {
                    vc.movieViewModel = movieModelView
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource extension
extension UpcomingMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMoviesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        cell.movieViewModel = upcomingMoviesViewModel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showMovieDetail", sender: upcomingMoviesViewModel[indexPath.row])
    }
}

extension UpcomingMoviesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y && self.lastContentOffset > 0) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        print(self.lastContentOffset)
        
    }
}

extension UpcomingMoviesViewController:  UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
}

