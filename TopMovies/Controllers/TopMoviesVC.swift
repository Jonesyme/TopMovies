//
//  TopMoviesVC.swift
//  TopMovies
//

import UIKit

class TopMoviesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!  // our main UICollectionView
    var movieRecordList:[MovieRecord] = []                // array of movie records fetched from Custom WebService
    var cache = NSCache<AnyObject, AnyObject>()           // used to cache movie posters images for reuse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.indicatorStyle = UIScrollViewIndicatorStyle.white
        
        if self.movieRecordList.count == 0 {
            self.fetchMovieList()
        }
    }
    
    // detect when device is rotated and notify UICollectionView to reload
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }

    // fetch JSON list of movies
    func fetchMovieList() {
        ZDWebService.sharedInstance.fetchAllMovies(success: { movieList in
            self.movieRecordList = movieList
            DispatchQueue.main.async() {
                self.collectionView.reloadData()
            }
        }, failure: { error in
            DispatchQueue.main.async() {
                self.collectionView.reloadData()
                self.displayDownloadFailureMessage(error!)
            }
        })
    }
    
    // display user-friendly error message should movie list download fail
    func displayDownloadFailureMessage(_ error: WebServiceError) {
        // display alert with error description, retry/fail option
        let alert = UIAlertController(title: "Download Failure", message: error.description + "\n\nDo you wish to retry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No",  style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] action in
            self.fetchMovieList()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UICollectionView Delegates
extension TopMoviesVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieRecordList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movieRecord = movieRecordList[indexPath.row]
        movieCell.movieRecord = movieRecord
        movieCell.posterImageView.image = nil
        movieCell.configureCellContent()
        
        // fetch movie poster from remote server if we haven't already
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) == nil) {
            PosterWebService.sharedInstance.fetchMoviePosterImage(movieId: movieRecord.id, success:{ image in
                self.cache.setObject(image, forKey: (indexPath as NSIndexPath).row as AnyObject)
                // update image of cell from original thread only if it's still visible on screen (avoids overwriting recycled cells while scrolling)
                if let updateCell = self.collectionView.cellForItem(at:indexPath) as? MovieCollectionViewCell {
                    DispatchQueue.main.async() { () -> Void in
                        updateCell.activityView.stopAnimating()
                        updateCell.activityView.isHidden = true
                        updateCell.posterImageView.image = image
                    }
                }
            }, failure: { error in
                print("WebService Image Fetch Error: \(error!.description)")
            })
        }
        
        return movieCell
    }
}

// MARK: - UICollectionViewDelegate
extension TopMoviesVC: UICollectionViewDelegate {
    
    // perform final preparations to display CollectionView cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movieCell = cell as! MovieCollectionViewCell
        
        // assign movie poster image from cache
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            movieCell.activityView.stopAnimating()
            movieCell.activityView.isHidden = true
            movieCell.posterImageView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }
        // prepare contents for display
        movieCell.prepareForDisplay()
    }
    
    // push movieDetailVC onto navigation stack
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "movieDetailVC") as! MovieDetailVC
        
        movieDetailVC.movieRecord = movieRecordList[indexPath.row]
        movieDetailVC.posterImage = cell.posterImageView.image
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
}

// MARK: - UICollectionViewFlowLayout
extension TopMoviesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = min(collectionView.frame.width, collectionView.frame.height) - 10
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellWidth = (collectionView.frame.width / 2) - 10 // display 2-cell-wide table on iPad
        }
        return CGSize(width: cellWidth, height: 300)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var leftRightInset = CGFloat(2.50)
        if UIDevice.current.userInterfaceIdiom == .pad {
            leftRightInset = CGFloat(5.00)
        }
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
}





