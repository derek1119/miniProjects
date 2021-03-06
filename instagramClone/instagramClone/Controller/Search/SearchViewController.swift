//
//  SearchViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

class SearchViewController: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var users = [User]()
    var filteredUsers = [User]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    var posts = [Post]()
    var currentKey: String?
    var userCurrentKey: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        tableView.register(SearchUserTableViewCell.self)
        
        tableView.separatorStyle = .none
        
        // configure search bar
        configureSearchBar()
        
        // fetch post
        fetchPosts()
        
        // configure collectionView
        configureCollectionView()
        
        // configure refresh control
        configureRefreshControl()
        
        // Notification Center addObserver
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: .fetchNewData, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if users.count > 3 {
            if indexPath.row == users.count - 1 {
                fetchUsers()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchUserTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        if inSearchMode {
            cell.user = filteredUsers[indexPath.row]
        } else {
            cell.user = users[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var user: User!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        // create instance of user profile vc
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // ????????? user ???????????? ??????
        userProfileVC.user = user
        
        // push view controller
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - UICollectionView
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: CGFloat().windowWidth, height: CGFloat().windowHeight - (tabBarController?.tabBar.frame.height)!)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(SearchPostCell.self)
        
        tableView.addSubview(collectionView)
        tableView.separatorColor = .clear
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 20 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchPostCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.post = posts[indexPath.item]
        feedVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    // MARK: - UISearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        // fetch users
        fetchUsers()
        
        collectionView.isHidden = true
        collectionViewEnabled = false
        
        tableView.separatorColor = .lightGray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // handle search text change
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredUsers = users.filter {
                $0.username!.contains(searchText)
            }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        inSearchMode = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        collectionViewEnabled = true
        
        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        
        if userCurrentKey == nil {
            USER_REF.queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let uid = snapshot.key
                    
                    Database.fetchUser(with: uid) { user in
                        self.users.append(user)
                        self.tableView.reloadData()
                    }
                }
                self.userCurrentKey = first.key
            }
        } else {
            USER_REF.queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let uid = snapshot.key
                    
                    if uid != self.userCurrentKey {
                        Database.fetchUser(with: uid) { user in
                            self.users.append(user)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.userCurrentKey = first.key
            }
        }
        /*
        // childAdd??? ???????????? ????????? ?????? ???????????? ?????? ???????????? ?????? ??????????????? ???????????? ???????????? ????????? value??? ???????????? ????????? ????????? ?????? ?????? ???????????? ????????? ??????????????? ????????? ????????????. ?????? value??? ?????? ???????????? ??? ????????? ?????? ?????? ??? ????????????, childadd, modified ?????? ??? ???????????? ??????????????? ????????? ???????????? ??? ????????? ??????????????? ????????????.
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            // uid
            let uid = snapshot.key
            Database.fetchUser(with: uid) { user in
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
        */
    }
    
    func fetchPosts() {
        
        if currentKey == nil {
            
            // initial data pull
            POSTS_REF.queryLimited(toLast: 21).observeSingleEvent(of: .value) { snapshot in
                self.tableView.refreshControl?.endRefreshing()

                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let postId = snapshot.key
                    
                    Database.fetchPosts(with: postId) { post in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    }
                }
                self.currentKey = first.key
            }
        } else {
            
            // paginate here
            
            POSTS_REF.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        Database.fetchPosts(with: postId) { post in
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        }
                    }
                }
                self.currentKey = first.key
            }
        }
    }
}
