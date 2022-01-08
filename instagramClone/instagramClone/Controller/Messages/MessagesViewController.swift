//
//  MessageViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/28.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation
        configureNavigationBar()
        
        // register cell
        tableView.register(MessageCell.self)
        
        // fetch messages
        fetchMessages()
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerID = message.getChatPartnerId()
        Database.fetchUser(with: chatPartnerID) { user in
            self.showChatController(forUser: user)
        }
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
        let chatVC = ChatController()
        chatVC.user = user
        chatVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메세지"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    // MARK: - API
    
    func fetchMessages() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.messages.removeAll()
        self.messageDictionary.removeAll()
        self.tableView.reloadData()
        
        USER_MESSAGES_REF.child(currentUid).observe(.childAdded) { snapshot in
            
            let uid = snapshot.key
            
            USER_MESSAGES_REF.child(currentUid).child(uid).observe(.childAdded) { snapshot in
                let messageId = snapshot.key
                
                self.fetchMessage(withMessageId: messageId)
            }
        }
        
    }
    
    func fetchMessage(withMessageId messageId: String) {
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let message = Message(dictionary: dictionary)
            let chatPartnerID = message.getChatPartnerId()
            // 동일한 아이디를 중복해서 표시하는 것을 방지하기 위한 방법, 동일 아이디의 최근 메세지를 표시
            self.messageDictionary[chatPartnerID] = message
            self.messages = Array(self.messageDictionary.values)
            
            self.tableView.reloadData()
        }
    }
    
}
