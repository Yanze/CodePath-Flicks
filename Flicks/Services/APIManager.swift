//
//  APIManager.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation
import AFNetworking

class APImanager: NSObject {
    
    static let sharedInstance = APImanager()
    let manager = AFHTTPSessionManager()
    
//    func getAPIKey() {
//        let myDict: NSDictionary?
//        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
//            let myDict = NSDictionary(contentsOfFile: path)
//            if let dict = myDict {
//                print(dict)
//            }
//        }
//    }

    
    func getNowPlayingMovies(completionHandler: @escaping([[String: Any]]) -> Void) {
        manager.get("https://api.themoviedb.org/3/movie/now_playing?api_key=e0eb8726a48468939860070cb3a0bc04&language=en-US&page=1", parameters: nil, progress: nil, success: { (operation, response) in
            
            if let dict = response as? [String: Any], let data = dict["results"] as? [[String: Any]] {
                completionHandler(data)
            }
            
            
        }) { (operation, error) in
            print(error)
        }
    }
    
    func getTopRatedMovies(completionHandler: @escaping([[String: Any]]) -> Void) {
        manager.get("https://api.themoviedb.org/3/movie/top_rated?api_key=e0eb8726a48468939860070cb3a0bc04&language=en-US&page=1", parameters: nil, progress: nil, success: { (operation, response) in
            
            if let dict = response as? [String: Any], let data = dict["results"] as? [[String: Any]] {
                completionHandler(data)
            }
            
        }) { (opration, error) in
            print(error)
        }
    }
    
    
    func getMoviesUnTime() {
        
    }
    
    
}
