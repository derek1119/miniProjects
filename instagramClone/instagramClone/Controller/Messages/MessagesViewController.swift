//
//  MessageViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/28.
//

import UIKit
import Firebase

private let reuserIdentifier = "MessageCell"

class MessagesViewController: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation
        configureNavigationBar()
        
        // register cell
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuserIdentifier)
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
    // MARK: - Handlers
    
    @objc func handleNewMessage() {
        print(#function)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메세지"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    
    
}
