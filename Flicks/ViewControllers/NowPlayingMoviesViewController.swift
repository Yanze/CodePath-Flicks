//
//  ViewController.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import SVProgressHUD

class NowPlayingMoviesViewController: UITableViewController {
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getNowPlayingMovies()
        
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
    
    //MARK: tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCustomCell
        cell.movie = movies[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "nowPlayingDetail" {
            let detailVc = segue.destination as! DetailViewController
            detailVc.movie = self.movies[(indexPath?.row)!]
        }
    }
    

}

