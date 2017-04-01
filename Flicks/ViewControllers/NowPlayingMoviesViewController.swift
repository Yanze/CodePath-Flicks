//
//  ViewController.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import SVProgressHUD

class NowPlayingMoviesViewController: UITableViewController, NetworkConnectionDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var refreshMovieControl: UIRefreshControl!
    var movies = [Movie]()
    @IBOutlet var warningBar: UIView!
    var searchController = UISearchController(searchResultsController: nil)
    var filteredMovies = [Movie]()
    var detectedText = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.sharedInstance.delegate = self
        getNowPlayingMovies()
        setRefreshMovieControl()
        
        // search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationItem.titleView = searchController.searchBar
        

    }
    
    func setRefreshMovieControl() {
        refreshMovieControl = UIRefreshControl()
        refreshMovieControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshMovieControl.addTarget(self, action: #selector(refreshMovieList), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshMovieControl)
    }

    func getNowPlayingMovies() {
        SVProgressHUD.show()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { 
            APImanagerHelper.sharedInstance.getNowPlayingMoviesHelper { (movies) in
                self.movies = movies
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func refreshMovieList() {
        APImanagerHelper.sharedInstance.getNowPlayingMoviesHelper { (movies) in
            self.movies = movies
            self.tableView.reloadData()
            self.refreshMovieControl.endRefreshing()
        }
    }
    
    //MARK: tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovies.count
        }
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCustomCell
//        cell.movie = movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")! as! MovieCustomCell
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.movie = filteredMovies[indexPath.row]
        }
        else {
            cell.movie = movies[indexPath.row]
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "nowPlayingDetail" {
            let detailVc = segue.destination as! DetailViewController
            detailVc.movie = self.movies[(indexPath?.row)!]
        }
    }
    
    @IBAction func dismissWarningBar(_ sender: UIButton) {
        connectionBannerAnimateOut()
    }
    
    
    //MARK: network delegate method
    func connectionBannerAnimateIn() {
        warningBar.frame.size.width = view.frame.size.width
        warningBar.center = view.center
        warningBar.frame.origin.y = -69
        warningBar.alpha = 0
        view.addSubview(warningBar)
        UIView.animate(withDuration: 1) {
            self.warningBar.alpha = 1
            self.warningBar.frame.origin.y = 0
        }
    }
    
    func connectionBannerAnimateOut() {
        UIView.animate(withDuration: 0.2) { 
            self.warningBar.alpha = 0
            self.warningBar.frame.origin.y = -69
        }
    }
    
    //MARK: search bar delegate methods
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = movies.filter { movie in
            return movie.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    

}

