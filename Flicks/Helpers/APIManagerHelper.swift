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
    var nowPlayingMovies = [Movie]()
    var topRatedMovies = [Movie]()
    
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
                
                self.nowPlayingMovies.append(newMovie)
            }
            completionHandler(self.nowPlayingMovies)
        }
    }
    
    
    func getTopRatedMoviesHelper(completionHandler: @escaping([Movie]) -> Void) {
        APImanager.sharedInstance.getTopRatedMovies { (data) in
            for topMovie in data {
                let movie = Movie()
                movie.title = topMovie["title"] as! String
                movie.language = topMovie["original_language"] as! String
                movie.overview = topMovie["overview"] as! String
                movie.release_date = topMovie["release_date"] as! String
                movie.poster_path = topMovie["poster_path"] as! String
                movie.vote_count = topMovie["vote_count"] as! Int
                movie.vote_average = topMovie["vote_average"] as! Float
                
                self.topRatedMovies.append(movie)
            }
            completionHandler(self.topRatedMovies)
        }
        
    }
    
    
}
