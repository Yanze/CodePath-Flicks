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
            let imageURL = "https://image.tmdb.org/t/p/w185/".appending(imageLink)
            let imageRequest = NSURLRequest(url: NSURL(string: imageURL)! as URL) as URLRequest
            
            movieImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imgRequest, imgResponse, image) in
                if imgResponse != nil {
                    self.movieImageView.alpha = 0
                    self.movieImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        self.movieImageView.alpha = 1
                    })
                }else {
                    self.movieImageView.image = image
                }
                
            }) { (imageRequest, imageResponse, error) in
                print(error)
            }
        }
    }
    
    
}
