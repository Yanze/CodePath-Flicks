//
//  ViewController.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import SVProgressHUD

class NowPlayingMoviesViewController: UITableViewController, NetworkConnectionDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIViewControllerTransitioningDelegate {
    
    var refreshMovieControl: UIRefreshControl!
    var movies = [Movie]()
    @IBOutlet var warningBar: UIView!
    var searchController = UISearchController(searchResultsController: nil)
    var currentMovies = [Movie]()
    var detectedText = ""
    var transition = CircularTransition()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.sharedInstance.delegates.append(self)
        setRefreshMovieControl()
        setupSearchBar()
        
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 0:
                print(0)
                getNowPlayingMovies()
            case 1:
                getTopRatedMovies()
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func setRefreshMovieControl() {
        refreshMovieControl = UIRefreshControl()
        refreshMovieControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        if let selectedTabIndex = tabBarController?.selectedIndex {
            switch selectedTabIndex {
            case 0:
                refreshMovieControl.addTarget(self, action: #selector(refreshPlayingMovieList), for: UIControlEvents.valueChanged)
            case 1:
                refreshMovieControl.addTarget(self, action: #selector(refreshTopRatedMovieList), for: UIControlEvents.valueChanged)
            default:
                break
            }
        }
        
        tableView.addSubview(refreshMovieControl)
    }

    func getNowPlayingMovies() {
        SVProgressHUD.show()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { 
            APImanagerHelper.sharedInstance.getNowPlayingMoviesHelper { (movies) in
                self.movies = movies
                self.currentMovies = movies
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func getTopRatedMovies() {
        SVProgressHUD.show()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            APImanagerHelper.sharedInstance.getTopRatedMoviesHelper { (movies) in
                self.movies = movies
                self.currentMovies = movies
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func refreshPlayingMovieList() {
        APImanagerHelper.sharedInstance.getNowPlayingMoviesHelper { (movies) in
            self.movies = movies
            self.tableView.reloadData()
            self.refreshMovieControl.endRefreshing()
        }
    }
    
    func refreshTopRatedMovieList() {
        APImanagerHelper.sharedInstance.getTopRatedMoviesHelper { (movies) in
            self.movies = movies
            self.tableView.reloadData()
            self.refreshMovieControl.endRefreshing()
        }
    }
    
    //MARK: tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")! as! MovieCustomCell
        
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor(red: 254/255, green: 36/255, blue: 48/255, alpha: 0.4)
        cell.selectedBackgroundView = customColorView
        cell.movie = currentMovies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailVC.transitioningDelegate = self
        detailVC.modalPresentationStyle = .custom
        detailVC.movie = currentMovies[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissWarningBar(_ sender: UIButton) {
        connectionBannerAnimateOut()
    }
    
    
    //MARK: network delegate method
    func connectionBannerAnimateIn() {
        warningBar.frame.size.width = view.frame.size.width
        warningBar.center = view.center
        warningBar.frame.origin.y = -(self.navigationController?.navigationBar.frame.height)!
        warningBar.alpha = 0
        view.addSubview(warningBar)
        UIView.animate(withDuration: 1) {
            self.warningBar.alpha = 1
            self.warningBar.frame.origin.y = 0
        }
    }
    
    func connectionBannerAnimateOut() {
        UIView.animate(withDuration: 0.4) {
            self.warningBar.alpha = 0
            self.warningBar.frame.origin.y = -(self.navigationController?.navigationBar.frame.height)!
        }
    }
    
    //MARK: search bar delegate methods
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let filteredMovies = movies.filter { movie in
            return movie.title.lowercased().contains(searchText.lowercased())
        }
   
        if searchController.isActive && searchController.searchBar.text != "" {
            currentMovies = filteredMovies
        }
        else {
            currentMovies = movies
        }
        tableView.reloadData()
    }
    
    // circular transition delegate methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! MovieCustomCell
        transition.startingPoint = cell.contentView.center
        transition.circleColor = cell.movieImageView.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! MovieCustomCell
        transition.startingPoint = cell.contentView.center
        transition.circleColor = cell.movieImageView.backgroundColor!
        return transition
    }

}

