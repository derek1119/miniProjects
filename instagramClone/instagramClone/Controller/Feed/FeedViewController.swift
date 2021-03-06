//
//  FeedViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase
import ActiveLabel
import Toast_Swift

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    var currentKey: String?
    var userProfileController: UserProfileViewController?
    var uploadPostVC: UploadPostViewController?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(FeedCell.self)
        
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
        
        // Notification Center addObserver
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: .fetchNewData, object: nil)
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 0 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewSinglePost ? 1 : posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
        cell.delegate = self

        cell.post = viewSinglePost ? post : posts[indexPath.row]
        
        handleHashtagTapped(forCell: cell)
        handleUsernameLabelTapped(forCell: cell)
        handleMentionTapped(forCell: cell)
        
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
        
        guard let post = cell.post else { return }
        
        if post.ownerUID == Auth.auth().currentUser?.uid {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "??????", style: .destructive, handler: { _ in
                post.deletePost()
                
                if !self.viewSinglePost {
                    self.handleRefresh()
                } else {
                    if let userProfileController = self.userProfileController {
                        self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefresh()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "??????", style: .default, handler: { _ in
                
                let uploadPostVC = UploadPostViewController()
                let navController = UINavigationController(rootViewController: uploadPostVC)
                uploadPostVC.postToEdit = post
                uploadPostVC.uploadAction = .saveChanges
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: "??????", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
            guard let image = cell.postImageView.image else { return }
            var shareContent = [UIImage]()
            shareContent.append(image)
            let activityController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
            activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                if completed {
                    self.showToast(message: "Share Success", self.view)
                } else {
                    self.showToast(message: "Share Cancel", self.view)
                }
                
                if let error = error {
                    self.showToast(message: "\(error.localizedDescription)", self.view)
                }
            }
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
       
        // ?????? ????????? ????????? ????????? ????????? ??????
        guard let post = cell.post else { return }
        
        if post.didLike {
            // ?????? ???????????? ???????????? ????????? ??? ?????? -> ?????? ??? ?????? ?????? ????????? ????????? ????????? ?????? ?????? ??????
            if !isDoubleTap {
                // handle unlike post
                post.adjustLikes(addLike: false) { likes in
                    cell.likesLabel.text = "????????? \(likes)???"
                    cell.likeButton.setImage(UIImage().Image("like_unselected"), for: .normal)
                }
            }
        } else {
            // handle like post
            post.adjustLikes(addLike: true) { likes in
                cell.likesLabel.text = "????????? \(likes)???"
                // cell??? ????????? ?????? selected??? ??????
                cell.likeButton.setImage(UIImage().Image("like_selected"), for: .normal)
            }
        }
    }
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        guard
            let currentUid = Auth.auth().currentUser?.uid,
            let post = cell.post else { return }
        let postId = post.postID
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            
            // user-like ???????????? post id??? ????????? ??????
            if snapshot.hasChild(postId) {
                post.didLike = true
                cell.likeButton.setImage(UIImage().Image("like_selected"), for: .normal)
            }
        }
    }
    
    func handleShowLikes(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let postId = post.postID
        let followLikeVC = FollowLikeViewController()
        followLikeVC.viewingMode = .Likes
        followLikeVC.postId = postId
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let commentVC = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.post = post
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(commentVC, animated: true)
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
        self.currentKey = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    @objc func handleShowMessages() {
        let messageVC = MessagesViewController()
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func handleHashtagTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleHashtagTap { hashtag in
            let hashtagVC = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagVC.hashtag = hashtag
            self.navigationController?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(hashtagVC, animated: true)
        }
    }
    
    func handleMentionTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleMentionTap { username in
            self.getMentionUser(withUsername: username)
        }
    }
    
    func handleUsernameLabelTapped(forCell cell: FeedCell) {
        
        guard let user = cell.post?.user else { return }
        guard let username = cell.post?.user?.username else { return }
        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        cell.captionLabel.handleCustomTap(for: customType) { _ in
            
            let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileVC.user = user
            self.navigationController?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
    }

    func configureNavigationBar() {
        if !viewSinglePost {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage().Image("send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        
        self.navigationItem.title = "??????"
    }
    
    @objc func handleLogOut() {
        
        // declare alert controller
        let alerController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // ???????????? ?????? ??????
        alerController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            do {
                // ???????????? ??????
                try Auth.auth().signOut()
                
                // present login controller
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                print("???????????? ??????")
            } catch {
                // ?????? ??????
                print("???????????? ?????? ", error.localizedDescription)
            }
        }))
        
        // ?????? ?????? ??????
        alerController.addAction(UIAlertAction(title: "??????", style: .cancel, handler: nil))
        
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
        
        if currentKey == nil {
            
            // ?????????????????? ????????? 5?????? ???????????? ?????? ???????????????.
            USER_FEED_REF.child(currentUid).queryLimited(toLast: 1).observeSingleEvent(of: .value) { snapshot in
                
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
            // ????????? currentkey??? ??????????????? ???????????? ???????????? ????????? 6?????? ???????????????(5?????????????????? ??????) --> ??????????????? ????????? ???
            USER_FEED_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 2).observeSingleEvent(of: .value) { snapshot in
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
}
