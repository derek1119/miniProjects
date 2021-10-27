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
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        // create instance of user profile vc
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // 선택된 user 데이터를 넘김
        userProfileVC.user = user
        
        // push view controller
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - Handlers
    
    func configureNavController() {
        navigationItem.title = "탐색"
    }
    
    // MARK: - API
    
    func fetchUser() {
        // childAdd를 사용하는 이유는 새로 들어오는 값만 가져와서 따로 딕셔너리를 만들어서 가져오는 반면에 value를 사용하면 차일드 아래에 있는 모든 데이터를 하나의 딕셔너리에 넣어서 가져온다. 결국 value는 한번 업데이트 할 때마다 모든 값을 다 가져오고, childadd, modified 등등 은 바뀌거나 수정되거나 추가된 이벤트인 그 정보만 컴팩트하게 가져온다.
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            
            // uid
            let uid = snapshot.key
            
            Database.fetchUser(with: uid) { user in
                
                self.users.append(user)
                
                self.tableView.reloadData()
                
            }
        }
    }
}
