//
//  MessageViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/28.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessageCell"

class MessagesViewController: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation
        configureNavigationBar()
        
        // register cell
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
    // MARK: - Handlers
    
    @objc func handleNewMessage() {
        let newMessageVC = NewMessageController()
        newMessageVC.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChatController(forUser user: User) {
        let chatVC = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        chatVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메세지"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    
    
}
