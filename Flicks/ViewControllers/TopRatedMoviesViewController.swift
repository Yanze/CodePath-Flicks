//
//  TopRatedMoviesViewController.swift
//  Flicks
//
//  Created by yanze on 3/30/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import SVProgressHUD

class TopRatedMoviesViewController: UITableViewController, NetworkConnectionDelegate {
    
    var refreshMovieControl: UIRefreshControl!
    var topRatedMovies = [Movie]()
    @IBOutlet var topRatedNetwokBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.sharedInstance.delegate = self
        getTopRatedMovies()
        setRefreshMovieControl()
    }
    
    func getTopRatedMovies() {
        SVProgressHUD.show()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { 
            APImanagerHelper.sharedInstance.getTopRatedMoviesHelper { (movies) in
                self.topRatedMovies = movies
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setRefreshMovieControl() {
        refreshMovieControl = UIRefreshControl()
        refreshMovieControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshMovieControl.addTarget(self, action: #selector(refreshMovieList), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshMovieControl)
    }
    
    func refreshMovieList() {
        APImanagerHelper.sharedInstance.getTopRatedMoviesHelper { (movies) in
            self.topRatedMovies = movies
            self.tableView.reloadData()
            self.refreshMovieControl.endRefreshing()
        }
    }
    
    @IBAction func dismissNetworkWarningBar(_ sender: UIButton) {
        connectionBannerAnimateOut()
    }
    
    
    //Mark: UItableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topRatedMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath) as! TopRatedMovieCell
        cell.movie = self.topRatedMovies[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "topratedDetail" {
            let detailVc = segue.destination as! DetailViewController
            detailVc.movie = self.topRatedMovies[(indexPath?.row)!]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //MARK: network delegate method
    func connectionBannerAnimateIn() {
        topRatedNetwokBar.frame.size.width = view.frame.size.width
        topRatedNetwokBar.center = view.center
        topRatedNetwokBar.frame.origin.y = -69
        topRatedNetwokBar.alpha = 0
        view.addSubview(topRatedNetwokBar)
        UIView.animate(withDuration: 1) {
            self.topRatedNetwokBar.alpha = 1
            self.topRatedNetwokBar.frame.origin.y = 0
        }
    }
    
    func connectionBannerAnimateOut() {
        UIView.animate(withDuration: 0.2) {
            self.topRatedNetwokBar.alpha = 0
            self.topRatedNetwokBar.frame.origin.y = -69
        }
    }
    
}
