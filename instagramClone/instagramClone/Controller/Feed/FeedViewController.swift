//
//  FeedViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "FeedCell"

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshControl = UIRefreshControl().then {
            $0.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        }
        collectionView.refreshControl = refreshControl
        

        //configure logout button
        configureNavigationBar()
        
        //fetch posts
        if !viewSinglePost {
            fetchPosts()
        }
        
        updateUserFeeds()
    }

    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewSinglePost ? 1 : posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
    
        cell.post = viewSinglePost ? post : posts[indexPath.row]
        cell.delegate = self
    
        return cell
    }

    // MARK: - FeedCellDelegate protocol
    
    func handleUserNameTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = post.user
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        print(#function)
    }
    
    func handleLikeTapped(for cell: FeedCell) {
       
        // 현재 유저가 좋아요 표시한 포스트 추가
        guard let post = cell.post else { return }
        
        if post.didLike {
            
            post.adjustLikes(addLike: false) { likes in
                cell.likesLabel.text = "좋아요 \(likes)개"
                cell.likeButton.setImage(UIImage().Image("like_unselected"), for: .normal)
            }
        } else {
            
            post.adjustLikes(addLike: true) { likes in
                cell.likesLabel.text = "좋아요 \(likes)개"
                // cell의 좋아요 마크 selected로 변경
                cell.likeButton.setImage(UIImage().Image("like_selected"), for: .normal)
            }
        }
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        print(#function)
    }
    
    func handleMessageTapped(for cell: FeedCell) {
        print(#function)
    }
    
    func handleSavePostTapped(for cell: FeedCell) {
        print(#function)
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        fetchPosts()
        collectionView.reloadData()
    }
    
    @objc func handleShowMessages() {
        print(#function)
    }

    func configureNavigationBar() {
        if !viewSinglePost {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage().Image("send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        
        self.navigationItem.title = "Feed"
    }
    
    @objc func handleLogOut() {
        
        // declare alert controller
        let alerController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 로그아웃 액션 추가
        alerController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            do {
                // 로그아웃 시도
                try Auth.auth().signOut()
                
                // present login controller
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                print("로그아웃 성공")
            } catch {
                // 에러 처리
                print("로그아웃 실패 ", error.localizedDescription)
            }
        }))
        
        // 취소 액션 추가
        alerController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alerController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func updateUserFeeds() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let followingUserID = snapshot.key
            
            USER_POSTS_REF.child(followingUserID).observe(.childAdded) { snapshot in
                
                let postID = snapshot.key
                USER_FEED_REF.child(currentUid).updateChildValues([postID: 1])
            }
        }
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let postID = snapshot.key
            USER_FEED_REF.child(currentUid).updateChildValues([postID: 1])
        }
    }
    
    func fetchPosts() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FEED_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let postId = snapshot.key
            
            Database.fetchPosts(with: postId) { post in
                self.posts.append(post)
                self.posts.sort { $0.creationDate > $1.creationDate }

                // stop refreshing
                self.collectionView.refreshControl?.endRefreshing()
                
                self.collectionView.reloadData()
            }
        }
    }
}
