//
//  PlayerViewController.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    var timeObserver: Any?
    var isSeeking: Bool = false
    let player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlayButton()
        updateTime(time: CMTime.zero)
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTineColor()
        updateTrackInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        player.replaceCurrentItem(with:nil)
    }

    @IBAction func beginDrag(_ sender : UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDrag(_ sender : UISlider) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender : UISlider) {
        guard let currentItem = player.currentItem else { return }
        let position = Double(sender.value)
        let seconds = currentItem.duration.seconds * position
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        player.seek(to: time)
    }
    
    @IBAction func togglePlayButton(_ sender : UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        updatePlayButton()
    }
    
    
}

extension PlayerViewController {
    func updateTrackInfo() {
        guard let track = player.currentItem?.convertToTrack() else { return }
        thumbnailImageView.image = track.artwork
        titleLabel.text = track.title
        artistLabel.text = track.artist
    }
    
    func updateTineColor() {
        playControlButton.tintColor = DefaultStyle.Colors.tint
        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    func updateTime(time: CMTime) {
        currentTimeLabel.text = secondsToString(sec: player.currentTime)
        totalDurationLabel.text = secondsToString(sec: player.totalDurationTime)
        
        if isSeeking == false {
            timeSlider.value = Float(player.currentTime/player.totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func updatePlayButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        if player.isPlaying {
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
    }
}

public enum DefaultStyle {
    public enum Colors {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollction in
                    if traitCollction.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
    }
}
