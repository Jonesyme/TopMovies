//
//  MovieCollectionViewCell.swift
//  TopMovies
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var movieRecord: MovieRecord? // data model
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOffset = CGSize(width: -2.00, height: 2.00)
        posterImageView.layer.shadowOpacity = 1
        posterImageView.layer.shadowRadius = 6

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.layer.shadowPath = UIBezierPath(roundedRect:posterImageView.bounds, cornerRadius:2.0).cgPath
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    // load cell content
    func configureCellContent() {
        if let movieRecord = movieRecord {
            if let movieRank = movieRecord.rank {
                rankLabel.text = String(describing:movieRank)
            }
            titleLabel.text = movieRecord.name
            descTextView.attributedText = movieRecord.attributedMovieDescriptionString(compactVersion:true)
            genreLabel.text = movieRecord.convertListToString(list: movieRecord.genres, maxElements: 3)
            durationLabel.text = movieRecord.duration
        }
    }
    
    // final preparations before diaplaying cell
    func prepareForDisplay() {
        // wrap description text around poster thumb image
        var imgRect = descTextView.convert(posterImageView.frame, from: self.contentView)
        imgRect.origin.x -= 5
        imgRect.size.width += 5
        let imgPath: UIBezierPath = UIBezierPath.init(rect: imgRect)
        descTextView.textContainer.exclusionPaths = [imgPath]
    }
    
    // overriden to recalc descTextView wrap around poster images after rotation or layout change
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        setNeedsLayout()
        layoutIfNeeded()
        prepareForDisplay()
    }
}

