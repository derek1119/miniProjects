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
    
    enum ViewingMode: Int {
        case Following
        case Followers
        case Likes
        
        init(index: Int) {
            switch index {
            case 0: self = .Following
            case 1: self = .Followers
            case 2: self = .Likes
            default: self = .Following
            }
        }
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
        
        
        if let viewingMode = viewingMode {
            // configure nav controller
            configureNavigationTitle(with: viewingMode)
            // fetch Users
            fetchUsers(by: viewingMode)
        }
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = .isEnableStateColor
        } else {
            user.follow()
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
        
    }
    
    // MARK: - Handlers
    func configureNavigationTitle(with viewingMode: ViewingMode) {
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
    
    func getDatabaseReference(_ viewingMode: ViewingMode) -> DatabaseReference? {
        switch viewingMode {
        case .Following:
            return USER_FOLLOWING_REF
        case .Followers:
            return USER_FOLLOWER_REF
        case .Likes:
            return POST_LIKES_REF
        }
    }
    
    func fetchUsers(by viewingMode: ViewingMode) {
        
        guard let ref = getDatabaseReference(viewingMode) else { return }
        
        switch viewingMode {
        case .Following, .Followers:
            guard let uid = uid else { return }
            // 만일 observe(.childadded)를 사용하면 노드에서부터 추가되는 데이터를 감지하기 때문에 추가되는 데이터와 추가된 데이터를 중복해서 나타낼 수 있다.
            ref.child(uid).observeSingleEvent(of: .value) { snapshot in
                // 전체 데이터를 한번에 불러온다
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                // 각각 데이터를 확인하여 추가한다.
                allObjects.forEach { snapshot in
                    let userId = snapshot.key
                    Database.fetchUser(with: userId) { user in
                        self.users.append(user)
                        self.tableView.reloadData()
                    }
                }
            }
        case .Likes:
            guard let postId = postId else {
                return
            }
            ref.child(postId).observe(.childAdded) { snapshot in
    
                let uid = snapshot.key
                
                Database.fetchUser(with: uid) { user in
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

