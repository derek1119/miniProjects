//
//  FollowViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit

private let reuseIdentifier = "FollowCell"

class FollowViewController: UITableViewController {
    
    var users = [User]()
    
    // MARK: - Properties
    
    var viewFollowers = false
    var viewFollowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell class
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // configure nav controller
        if viewFollowers {
            navigationItem.title = "팔로워"
        } else if viewFollowing {
            navigationItem.title = "팔로잉"
        } else {
            navigationItem.title = ""
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FollowCell else { return UITableViewCell() }
        
        return cell
    }
}
