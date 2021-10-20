//
//  SearchViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "SeachUserTableViewCell"

class SearchViewController: UITableViewController {

    // MARK: - Properties
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell classes
        tableView.register(SeachUserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // separator insets
                // 이미지의 너비(48) 만큼의 inset을 넣어줌 -> 64
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        configureNavController()
        
        // fetch Users
        fetchUser()
    }

    // MARK: - Table view data source
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SeachUserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        // create instance of user profile vc
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // 선택된 user 데이터를 넘김
        userProfileVC.userToLoadFromSearchVC = user
        
        // push view controller
        navigationController?.pushViewController(userProfileVC, animated: true)
    }

// MARK: - Handlers
    
    func configureNavController() {
        navigationItem.title = "Explore"
    }
    
    // MARK: - API
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            
            // uid
            let uid = snapshot.key
            
            // snapshot value case as dictionary
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            // append user to data source
            self.users.append(user)
            
            // reload our table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
