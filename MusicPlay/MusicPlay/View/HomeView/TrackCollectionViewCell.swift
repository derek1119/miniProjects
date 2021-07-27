//
//  TrackCollectionViewCell.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var trackThumbnail: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackArtist: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(item : Track?) {
        
    }
    
    func setUpConstraints() {
        self.trackThumbnail.layer.cornerRadius = 8.0
        self.trackArtist.textColor = .systemGray2
    }
}
