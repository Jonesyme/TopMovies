//
//  MovieDetailVC.swift
//  TopMovies
//

import UIKit

class MovieDetailVC: UIViewController {

    var movieRecord: MovieRecord? // data model
    var posterImage: UIImage?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var purchaseTixBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // insert background image
        let bgImageView = UIImageView.init(frame: self.view.frame)
        bgImageView.contentMode = .scaleToFill
        bgImageView.image = UIImage(named: "grayBG")
        self.view.insertSubview(bgImageView, at:0)
        
        posterImageView?.image = posterImage
        descTextView.attributedText = movieRecord?.attributedMovieDescriptionString(compactVersion: false)
    }

    // purchase tickets - will simply display UIWebView and open Google homepage
    @IBAction func purchaseTickets() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let webViewVC = storyboard.instantiateViewController(withIdentifier: "webViewVC") as! WebViewVC
        webViewVC.movieRecord = self.movieRecord
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}
