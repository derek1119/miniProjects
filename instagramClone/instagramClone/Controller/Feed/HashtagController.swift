//
//  HashtagController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/06.
//

import UIKit
import Firebase

private let reuserIdentifier = "HashtagCell"

class HashtagController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var hashtag: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        // register cell
        collectionView.register(HashtagCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        
        // fetch posts
        fetchPosts()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as? HashtagCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    // MARK: - Handlers
    func configureNavigationBar() {
        guard let hashtag = hashtag else { return }
        navigationItem.title = hashtag
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard let hashtag = hashtag else {
            return
        }
        HASHTAG_POST_REF.child(hashtag).observe(.childAdded) { snapshot in
            let postId = snapshot.key
            
            Database.fetchPosts(with: postId) { post in
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
        
    }
}
