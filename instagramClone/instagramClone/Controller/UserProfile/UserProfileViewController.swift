//
//  UserProfileViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "UserPostCell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    // MARK: - Properties
    
    var user: User?
    var posts = [Post]()
    var currentKey: String?
    var uploadPostVC: UploadPostViewController?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // configure refrech control
        configureRefreshControl()
        
        // fetch user data
        if user == nil {
            fetchCurrentUserData()
        }
        
        // fetch post
        fetchPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNewData), name: .fetchNewData, object: nil)
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // MARK: UICollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if posts.count > 9 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        header.delegate = self
        
        // set the user in header
        header.user = user
        navigationItem.title = user?.username
        
        // return header
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UserPostCell else { return UICollectionViewCell() }
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.userProfileController = self
        
        feedVC.post = posts[indexPath.item]
        feedVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    // MARK: - UserProfileHeader
    func handleEditFollowTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
            let editProfileVC = EditProfileController()
            editProfileVC.user = user
            editProfileVC.userProfileVC = self
            let navController = UINavigationController(rootViewController: editProfileVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }
    }
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        let FollowVC = FollowLikeViewController()
        FollowVC.viewingMode = .Followers
        FollowVC.uid = user?.uid
        navigationController?.pushViewController(FollowVC, animated: true)
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        let FollowVC = FollowLikeViewController()
        FollowVC.viewingMode = .Following
        FollowVC.uid = user?.uid
        navigationController?.pushViewController(FollowVC, animated: true)
    }
    
    
    func setUserStats(for header: UserProfileHeader) {
        
        guard let uid = header.user?.uid else { return }
        
        var numberOfFollowers: Int!
        var numberOfFollowing: Int!
        
        // get number of followers
        USER_FOLLOWER_REF.child(uid).observe(.value) { snapshot in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowers = snapshot.count
            } else {
                numberOfFollowers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "팔로워", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        // observeSingleEvent는 한번의 이벤트만 받고 끝나지만 observe는 실시간(realtime) 추적을 한다.
        USER_FOLLOWING_REF.child(uid).observe(.value) { snapshot in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "팔로잉", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followingLabel.attributedText = attributedText
        }
        
        let attributedText = NSMutableAttributedString(string: "\(self.posts.count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "게시물", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        header.postsLabel.attributedText = attributedText
    }
    
    // MARK: - Handlers
    
    @objc func fetchNewData() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - API
    
    func fetchPosts() {
        
        var uid: String!
        
        if let user = user {
            uid = user.uid
        } else {
            uid = Auth.auth().currentUser?.uid
        }
        
        // Initial data pull
        if currentKey == nil {
            
            USER_POSTS_REF.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    
                    let postId = snapshot.key
                    self.fetchPost(withPostId: postId)
                }
                self.currentKey = first.key
            }
        } else {
            USER_POSTS_REF.child(uid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 7).observeSingleEvent(of: .value) { snapshot in
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                }
                self.currentKey = first.key
            }
        }
    }
    
    func fetchPost(withPostId postId: String) {
        
        Database.fetchPosts(with: postId) { post in
            self.posts.append(post)
            
            self.posts.sort { $0.creationDate > $1.creationDate }
            self.collectionView.reloadData()
        }
        
    }
    
    func fetchCurrentUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dic = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dic)
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
}

