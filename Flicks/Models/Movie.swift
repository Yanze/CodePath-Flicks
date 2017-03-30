//
//  Movie.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation

class Movie: NSObject {
    var title: String
    var poster_path: String
    var release_date: String
    var language: String
    var overview: String
    var vote_count: Int
    var vote_average: Float
    
    override init() {
        self.title = ""
        self.poster_path = ""
        self.release_date = ""
        self.language = ""
        self.overview = ""
        self.vote_count = 0
        self.vote_average = 0.0
    }
    
    init(title: String, poster_path: String, release_date:String, language: String, overview: String, vote_count: Int, vote_average: Float) {
        self.title = title
        self.poster_path = poster_path
        self.release_date = release_date
        self.language = language
        self.overview = overview
        self.vote_count = vote_count
        self.vote_average = vote_average
    }
    
}
