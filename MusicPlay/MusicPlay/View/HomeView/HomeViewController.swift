//
//  HomeViewController.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit

class HomeViewController : UIViewController {
    
    let trackManager = TrackManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = trackManager.track(at: indexPath.item)
        cell.updateUI(item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManager.todaysTrack else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderReusableView", for: indexPath) as? TrackCollectionHeaderReusableView else {
                return UICollectionReusableView()
            }
            
            header.update(with: item)
            header.tapHandler = { item -> Void in
                //player를 띄운다.
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
                guard let vc = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
                vc.player.replaceCurrentItem(with: item)
                self.present(vc, animated: true, completion: nil)
                
            }
            
            return header
        default:
            return TrackCollectionHeaderReusableView()
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
        guard let vc = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
        let item = trackManager.tracks[indexPath.item]
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - (20 * 3))/2
        let height = width + 60
        
        return CGSize(width: width, height: height)
    }
}
