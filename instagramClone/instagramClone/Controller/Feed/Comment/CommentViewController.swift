//
//  CommentViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCell"

class CommentViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var comments = [Comment]()
    var post: Post?
    
    lazy var containerView = CommentInputAccessoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)).then {
        $0.backgroundColor = .white
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure collectionview
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        // navigation title
        navigationItem.title = "댓글"
        
        // register cell class
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // fetch Comments
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - UICollectionView

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40+8+8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
        
        handleHashtagTapped(forCell: cell)
        
        handleMentionTapped(forCell: cell)
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    // MARK: - Handlers
    
    func handleHashtagTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleHashtagTap { hashtag in
            let hashtagVC = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagVC.hashtag = hashtag
            self.navigationController?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(hashtagVC, animated: true)
        }
    }
    
    func handleMentionTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleMentionTap { username in
            self.getMentionUser(withUsername: username)
        }
    }
    
    // MARK: - API
    
    func fetchComments() {
        guard let postId = post?.postID else { return }
        
        COMMENT_REF.child(postId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid) { user in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
        }
    }
    
    func uploadCommentNotificationToServer() {
        
        guard
            let currentUid = Auth.auth().currentUser?.uid,
            let postID = post?.postID,
            let uid = post?.ownerUID else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // notification value
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "uid": currentUid,
                      "type": COMMENT_INT_VALUE,
                      "postID": postID] as [String : Any]
        
        if uid != currentUid {
            NOTIFICATIONS_REF.child(uid).childByAutoId().updateChildValues(values)
        }
    }
}


extension CommentViewController: CommentInputAccessoryViewDelegate {
    
    func didSummit(forComment comment: String) {
        guard
            let postId = post?.postID,
            let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let values = ["commentText" : comment,
                      "creationDate" : creationDate,
                      "uid" : uid] as [String: Any]
        
        COMMENT_REF.child(postId).childByAutoId().updateChildValues(values) { err, ref in
            self.uploadCommentNotificationToServer()
            if comment.contains("@") {
                self.uploadMentionNotification(forPostId: postId, withText: comment, isForComment: true)
            }
            self.containerView.clearCommentTextView()
        }
    }
}
