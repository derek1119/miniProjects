//
//  NewMessageController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    var users = [User]()
    var messagesController: MessagesViewController?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation
        configureNavigationBar()
        
        // register cell
        tableView.register(NewMessageCell.self)
        
        // fetch users
        fetchUsers()
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewMessageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "새로운 메세지"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - API
    
    func fetchUsers() {
        USER_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            
            if uid != Auth.auth().currentUser?.uid {
                Database.fetchUser(with: uid) { user in
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
