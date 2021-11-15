//
//  FollowViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowCell"

class FollowLikeViewController: UITableViewController, FollowCellDelegate {
    
    // MARK: - Properties
    
    var followCurrentKey: String?
    var likeCurrentKey: String?
    
    enum ViewingMode: Int {
        case Following
        case Followers
        case Likes
    }
    
    var viewingMode: ViewingMode!
    var uid: String?
    var users = [User]()
    var postId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell class
        tableView.register(FollowLikeCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // clear seperator line
        tableView.separatorColor = .clear
        
        // configure nav controller
        configureNavigationTitle()
        
        // fetch Users
        fetchUsers()
        
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if users.count > 3 {
            if indexPath.row == users.count - 1 {
                fetchUsers()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FollowLikeCell else { return UITableViewCell() }
        cell.user = users[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    
    // MARK: - Handler
    func handleFollowTapped(for cell: FollowLikeCell) {
        
        guard let user = cell.user else { return }
        if user.isFollowed {
            user.unfollow()
            cell.followButton.followStyle()
        } else {
            user.follow()
            cell.followButton.followingStyle()
        }
        
    }
    
    // MARK: - Handlers
    func configureNavigationTitle() {
        guard let viewingMode = viewingMode else { return }
        switch viewingMode {
        case .Following:
            navigationItem.title = "팔로잉"
        case .Followers:
            navigationItem.title = "팔로워"
        case .Likes:
            navigationItem.title = "좋아요"
        }
    }
    
    // MARK: - API
    
    func getDatabaseReference() -> DatabaseReference? {
        guard let viewingMode = viewingMode else { return nil }
        switch viewingMode {
        case .Following:
            return USER_FOLLOWING_REF
        case .Followers:
            return USER_FOLLOWER_REF
        case .Likes:
            return POST_LIKES_REF
        }
    }
    
    func fetchUser(withUid userId: String) {
        Database.fetchUser(with: userId) { user in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    func fetchUsers() {
        
        guard let viewingMode = viewingMode else { return }
        guard let ref = getDatabaseReference() else { return }
        
        switch viewingMode {
        case .Following, .Followers:
            guard let uid = uid else { return }
            
            if followCurrentKey == nil {
                
                ref.child(uid).queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
                    
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let followUid = snapshot.key
                        self.fetchUser(withUid: followUid)
                    }
                    self.followCurrentKey = first.key
                }
                
            } else {
                ref.child(uid).queryOrderedByKey().queryEnding(atValue: self.followCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let followUid = snapshot.key
                        if self.followCurrentKey != followUid {
                            self.fetchUser(withUid: followUid)
                        }
                    }
                    self.followCurrentKey = first.key
                }
            }
        case .Likes:
            guard let postId = postId else { return }
            
            if likeCurrentKey == nil {
                ref.child(postId).queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let likeUid = snapshot.key
                        self.fetchUser(withUid: likeUid)
                    }
                    self.likeCurrentKey = first.key
                }
            } else {
                ref.child(postId).queryOrderedByKey().queryEnding(atValue: self.likeCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                    allObjects.forEach { snapshot in
                        let likeUid = snapshot.key
                        if self.likeCurrentKey != likeUid {
                            self.fetchUser(withUid: likeUid)
                        }
                    }
                    self.likeCurrentKey = first.key
                }
            }
        }
    }
}

