//
//  FeedViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "FeedCell"

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    var currentKey: String?
    var userProfileController: UserProfileViewController?
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
    
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
            
            alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                post.deletePost()
                
                if !self.viewSinglePost {
                    self.handleRefresh()
                } else {
                    if let userProfileController = self.userProfileController {
                        self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefrech()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                
                let uploadPostVC = UploadPostViewController()
                let navController = UINavigationController(rootViewController: uploadPostVC)
                uploadPostVC.postToEdit = post
                uploadPostVC.uploadAction = .saveChanges
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
            // 다른 게시물의 옵션을 넣는 부분
            // UIActivityViewController
        }
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
       
        // 현재 유저가 좋아요 표시한 포스트 추가
        guard let post = cell.post else { return }
        
        if post.didLike {
            // 더블 탭으로는 좋아요만 표시할 수 있음 -> 한번 더 더블 탭을 한다고 좋아요 취소가 되는 것은 아님
            if !isDoubleTap {
                // handle unlike post
                post.adjustLikes(addLike: false) { likes in
                    cell.likesLabel.text = "좋아요 \(likes)개"
                    cell.likeButton.setImage(UIImage().Image("like_unselected"), for: .normal)
                }
            }
        } else {
            // handle like post
            post.adjustLikes(addLike: true) { likes in
                cell.likesLabel.text = "좋아요 \(likes)개"
                // cell의 좋아요 마크 selected로 변경
                cell.likeButton.setImage(UIImage().Image("like_selected"), for: .normal)
            }
        }
    }
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        guard
            let currentUid = Auth.auth().currentUser?.uid,
            let post = cell.post,
            let postId = post.postID else { return }
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            
            // user-like 데이터에 post id가 있는지 확인 
            if snapshot.hasChild(postId) {
                post.didLike = true
                cell.likeButton.setImage(UIImage().Image("like_selected"), for: .normal)
            }
        }
    }
    
    func handleShowLikes(for cell: FeedCell) {
        guard
            let post = cell.post,
            let postId = post.postID else { return }
              
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
        
        self.navigationItem.title = "피드"
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
        
        if currentKey == nil {
            
            // 파이어베이스 마지막 5개의 데이터만 일단 불러오겠다.
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
            // 마지막 currentkey의 데이터까지 포함해서 불러오기 때문에 6개를 지정하였다(5개를불러오기 위함) --> 추가적으로 찾아볼 것
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
