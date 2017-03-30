//
//  MoviesCustomCell.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class MovieCustomCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    
    
    var movie: Movie? {
        didSet {
            overviewLabel.lineBreakMode = .byTruncatingTail
            setupViews()
        }
    }
    
    func setupViews() {
        if let title = movie?.title {
            titleLabel.text = title
        }
        if let overview = movie?.overview {
            overviewLabel.text = overview
        }
        if let imageLink = movie?.poster_path {
            let baseURL = "https://image.tmdb.org/t/p/w185/"
            movieImageView.setImageWith(URL(string: baseURL.appending(imageLink))!, placeholderImage: UIImage(named: "default_poster"))
        }

        
    }
    
    
}
