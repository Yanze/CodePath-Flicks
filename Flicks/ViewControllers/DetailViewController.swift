//
//  NowPlayingDetailViewController.swift
//  Flicks
//
//  Created by yanze on 3/29/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var titleLabel: UILabel!
    var overviewLabel: UILabel!
    var releaseDateLabel: UILabel!
    var grayView: UIView!
    var movie = Movie()
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie.title
        navigationController?.navigationBar.tintColor = .white
        setupScrollView()
        setupTitleLabel()
        loadMobiePoster()
        setupReleaseDateLabel()
        setupOverviewLabel()
        setupDismissButton()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//    }
    
    
    @IBAction func dismissDetailVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupDismissButton() {
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = .red
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.layer.masksToBounds = true
    }

    
    func setupScrollView() {
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height + 100
        
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        grayView = UIView(frame: CGRect(x: 20, y: scrollView.frame.height - 150, width: scrollView.frame.width - 40, height: 260))
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        scrollView.addSubview(grayView)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: grayView.frame.width-20, height: 20))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.text = movie.title
        grayView.addSubview(titleLabel)
    }
    
    func loadMobiePoster() {
        let imageURL = "https://image.tmdb.org/t/p/original".appending(self.movie.poster_path)
        let imageRequest = NSURLRequest(url: NSURL(string: imageURL)! as URL) as URLRequest
        
        posterImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imgRequest, imgResponse, image) in
            if imgResponse != nil {
                self.posterImageView.alpha = 0
                self.posterImageView.image = image
                UIView.animate(withDuration: 0.1, animations: {
                    self.posterImageView.alpha = 1
                })
            }else {
                self.posterImageView.image = image
            }
            
        }) { (imageRequest, imageResponse, error) in
            print(error)
        }
    }
    
    func setupOverviewLabel() {
        overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textColor = .white
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.numberOfLines = 0
        overviewLabel.font = UIFont(name: "PingFangSC-Light", size: 14)
        
        if movie.overview.characters.count > 300 {
            let range =  movie.overview.rangeOfComposedCharacterSequences(for: movie.overview.startIndex..<movie.overview.index(movie.overview.startIndex, offsetBy: 300))
            overviewLabel.text = movie.overview.substring(with: range).appending("...")
        }
        else {
            overviewLabel.text = movie.overview
        }

        grayView.addSubview(overviewLabel)
        setupOverviewConstraints()
    }
    
    func setupReleaseDateLabel() {
        releaseDateLabel = UILabel()
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.textColor = .white
        releaseDateLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
         
        releaseDateLabel.text = movie.release_date
        grayView.addSubview(releaseDateLabel)
        setupReleaseDateLabelConstraints()
    }
    
    //MARKS: constraints
    func setupReleaseDateLabelConstraints() {
        releaseDateLabel.leftAnchor.constraint(equalTo: grayView.leftAnchor, constant: 15).isActive = true
        releaseDateLabel.rightAnchor.constraint(equalTo: grayView.rightAnchor, constant: -15).isActive = true
        releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setupOverviewConstraints() {
        overviewLabel.leftAnchor.constraint(equalTo: grayView.leftAnchor, constant: 15).isActive = true
        overviewLabel.rightAnchor.constraint(equalTo: grayView.rightAnchor, constant: -15).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    
    
    
    
    
}
