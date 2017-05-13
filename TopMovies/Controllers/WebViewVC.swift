//
//  WebViewVC.swift
//  TopMovies
//

import UIKit

class WebViewVC : UIViewController {

    var movieRecord: MovieRecord? // data model
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
    }
}

// MARK: UIWebViewDelegate
extension WebViewVC : UIWebViewDelegate {
    
    // start / stop activity spinner
    public func webViewDidStartLoad(_ webView: UIWebView) {
        activityView.startAnimating()
    }
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView.stopAnimating()
    }
    
    // simply display error message alert
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityView.stopAnimating()
        let alert = UIAlertController(title: "Download Failure", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
