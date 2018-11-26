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
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noMoviesView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - ViewController life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noMoviesView.isHidden = true
        self.navigationItem.title = "Upcoming Movies"
        self.navigationItem.leftBarButtonItem = nil
        tableView.lock()
        setupUpcomingMoviesViewModelObserver()
        self.tableView.reloadData()
        
    }
    
    //MARK: - Rx Setup
    private func setupUpcomingMoviesViewModelObserver() {
        
        if Connectivity.isConnectedToInternet() {
            upcomingMoviesViewModel.upcomingMoviesObservable
                .subscribe(onNext: { movies in
                    
                    self.tableView.reloadData()
                    self.tableView.unlock()
                    
                    if self.upcomingMoviesViewModel.count == 0 {
                        self.noMoviesView.isHidden = false
                        self.errorLabel.text = "There are no movies to show right now."
                    } else {
                        self.noMoviesView.isHidden = true
                    }

                })
                .disposed(by: disposeBag)
        } else {
            self.noMoviesView.isHidden = false
            self.errorLabel.text = "No internet connection detected. Please, check it and try again."
        }
    }
    
    private func setupSearchedMoviesViewModelObserver() {
        if Connectivity.isConnectedToInternet() {
            searchingMovieViewModel.searchingMoviesObservable
                .subscribe(onNext: { movies in
                    
                    self.tableView.reloadData()
                    self.tableView.unlock()
                    
                    if self.searchingMovieViewModel.count == 0 {
                        self.noMoviesView.isHidden = false
                        self.errorLabel.text = "There are no movies to show right now."
                    } else {
                        self.noMoviesView.isHidden = true
                    }
                })
                .disposed(by: disposeBag)
        } else {
            self.noMoviesView.isHidden = false
            self.errorLabel.text = "No internet connection detected. Please, check it and try again."
        }
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
        self.navigationItem.leftBarButtonItem = nil
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
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 211.0
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
        self.lastContentOffset = scrollView.contentOffset.y
        
    }
}

//MARK: - UISearchBar extension
extension MovieListViewController:  UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableView.setContentOffset(tableView.contentOffset, animated: false)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.subviews[0].subviews.compactMap(){ $0 as? UITextField }.first?.tintColor = .darkGray
        searchBar.placeholder = ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Search any movie by name"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            searching = true
            self.tableView.lock()
            searchingMovieViewModel = SearchingMovieViewModel(name: searchBar.text!)
            navigationItem.title = "Search: " + searchBar.text!
            navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(cancelSearch))
            setupSearchedMoviesViewModelObserver()
            self.tableView.reloadData()
            
        } else {
            self.tableView.lock()
            cancelSearch()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//            if self.tableView.numberOfSections > 0 && self.tableView.numberOfRows(inSection: 0) > 0 {
//                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//            }
//        }
        
        dismissKeyboard()
    }
}

