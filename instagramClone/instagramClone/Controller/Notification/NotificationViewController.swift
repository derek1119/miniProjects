//
//  NotificationViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // clear separator lines
        tableView.separatorColor = .clear
        
        // register cell
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // navigation title
        navigationItem.title = "알림"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? NotificationCell else { return UITableViewCell()}
        return cell
    }
}
