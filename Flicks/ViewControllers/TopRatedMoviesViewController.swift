//
//  TopRatedMoviesViewController.swift
//  Flicks
//
//  Created by yanze on 3/30/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import SVProgressHUD

class TopRatedMoviesViewController: UITableViewController {
    
    var topRatedMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopRatedMovies()
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
    
}
