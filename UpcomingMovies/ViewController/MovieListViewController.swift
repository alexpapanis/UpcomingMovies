//
//  UpcomingMoviesViewController.swift
//  UpcomingMovies
//
//  Created by Alexandre Papanis on 21/11/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift

class MovieListViewController: UIViewController {

    //MARK: - Variables
    private let disposeBag = DisposeBag()
    private let upcomingMoviesViewModel = UpcomingMovieViewModel()
    private var searchingMovieViewModel = SearchingMovieViewModel()
    var searching: Bool = false
    private var lastContentOffset: CGFloat = 0
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Upcoming Movies"
        setupUpcomingMoviesViewModelObserver()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Rx Setup
    private func setupUpcomingMoviesViewModelObserver() {
        upcomingMoviesViewModel.upcomingMoviesObservable
            .subscribe(onNext: { movies in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchedMoviesViewModelObserver() {
        
        searchingMovieViewModel.searchingMoviesObservable
            .subscribe(onNext: { movies in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail"{
            if let vc = segue.destination as? MovieDetailViewController {
                if let movieModelView = sender as? MovieViewModel {
                    vc.movieViewModel = movieModelView
                }
            }
        }
    }
    
    //MARK: - Functions
    @objc func dismissKeyboard() {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    @objc func cancelSearch(){
        searching = false
        navigationItem.title = "Upcoming Movies"
        setupUpcomingMoviesViewModelObserver()
    }
    
}

//MARK: - UITableView extension
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searching ?
                    searchingMovieViewModel.count : upcomingMoviesViewModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        cell.movieViewModel = searching ? searchingMovieViewModel[indexPath.row] : upcomingMoviesViewModel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = searching ? searchingMovieViewModel[indexPath.row] : upcomingMoviesViewModel[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: movie)
    }
}

//MARK: - UIScrollView extension
extension MovieListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y && self.lastContentOffset > 0) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        
    }
}

//MARK: - UISearchBar extension
extension MovieListViewController:  UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            searching = true
            
            searchingMovieViewModel = SearchingMovieViewModel(name: searchBar.text!)
            navigationItem.title = "Search: " + searchBar.text!
            setupSearchedMoviesViewModelObserver()
            
        } else {
            cancelSearch()
        }
        
        DispatchQueue.main.async(execute: {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        })
        
        dismissKeyboard()
    }
}

