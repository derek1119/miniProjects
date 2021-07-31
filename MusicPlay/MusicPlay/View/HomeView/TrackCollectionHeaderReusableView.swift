//
//  TrackCollectionHeaderReusableView.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit
import AVFoundation

class TrackCollectionHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var item : AVPlayerItem?
    var tapHandler: ((AVPlayerItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 8
    }
    
    func update(with item: AVPlayerItem) {
        self.item = item
        guard let track = item.convertToTrack() else { return }

        self.thumbnailImageView.image = track.artwork
        self.descriptionLabel.text = "Today's pick is \(track.artist)'s album, Let listen"
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        guard let todaysItem = item else {
            return
        }
        
        tapHandler?(todaysItem)
    }
    
}
