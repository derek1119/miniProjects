//
//  HomeViewController.swift
//  MusicPlay
//
//  Created by Sh Hong on 2021/07/27.
//

import UIKit

class HomeViewController : UIViewController {
    
    let trackManager = TrackManager()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
    }
    
    func setConstraints() {
        collectionView.delegate = self
        collectionView.dataSource = self
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
            return TrackCollectionHeaderReusableView()
        default:
            return TrackCollectionHeaderReusableView()
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing: CGFloat = 20
        let inset : CGFloat = 20
        let width = (collectionView.bounds.width - itemSpacing - inset*2)/2
        let height = width * 1.3
        
        return CGSize(width: width, height: height)
    }
}
