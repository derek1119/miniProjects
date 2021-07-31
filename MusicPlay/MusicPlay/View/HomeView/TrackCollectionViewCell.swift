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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpConstraints()
    }
    
    func updateUI(item : Track?) {
        if let track = item {
            self.trackThumbnail.image = track.artwork
            self.trackTitle.text = track.title
            self.trackArtist.text = track.artist
        }
    }
    
    func setUpConstraints() {
        self.trackThumbnail.layer.cornerRadius = 8
        self.trackArtist.textColor = .systemGray2
    }

}
