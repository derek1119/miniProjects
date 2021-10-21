//
//  FollowViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowCell"

class FollowViewController: UITableViewController, FollowCellDelegate {
    
    // MARK: - Properties
    
    var viewFollowers = false
    var viewFollowing = false
    var uid: String?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell class
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // configure nav controller
        navigationItem.title = viewFollowers ? "팔로워" : "팔로잉"
        
        // clear seperator line
        tableView.separatorColor = .clear
        
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FollowCell else { return UITableViewCell() }
        cell.user = users[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Handler
    func handleFollowTapped(for cell: FollowCell) {
        
        guard let user = cell.user else { return }
        if user.isFollowed {
            user.unfollow()
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        } else {
            user.follow()
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
        
    }
    
    func fetchUsers() {
        
        guard let uid = uid else { return }
        var ref: DatabaseReference!
        ref = viewFollowers ? USER_FOLLOWER_REF : USER_FOLLOWING_REF
        
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
    }
}

