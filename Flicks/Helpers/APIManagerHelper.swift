//
//  APIManagerHelper.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation


class APImanagerHelper: NSObject {
    
    static let sharedInstance = APImanagerHelper()
    var movies = [Movie]()
    
    func getNowPlayingMoviesHelper(completionHandler: @escaping([Movie]) -> Void) {
        APImanager.sharedInstance.getNowPlayingMovies { (data) in
            
            for movie in data {
                let newMovie = Movie()
                newMovie.title = movie["title"] as! String
                newMovie.language = movie["original_language"] as! String
                newMovie.overview = movie["overview"] as! String
                newMovie.release_date = movie["release_date"] as! String
                newMovie.poster_path = movie["poster_path"] as! String
                newMovie.vote_count = movie["vote_count"] as! Int
                newMovie.vote_average = movie["vote_average"] as! Float
                
                self.movies.append(newMovie)
            }
            completionHandler(self.movies)
        }
    }
    
    
}
