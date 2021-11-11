//
//  NotificationViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "NotificationCell"

class NotificationViewController: UITableViewController, NotificationCellDelegate {
 
    // MARK: - Properties
    
    var timer: Timer?
    var currentKey: String?
    
    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // clear separator lines
        tableView.separatorColor = .clear
        
        // register cell
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // navigation title
        navigationItem.title = "알림"
        
        // fetch notification
        fetchNotification()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notifications.count > 4 {
            if indexPath.row == notifications.count - 1 {
                fetchNotification()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? NotificationCell else { return UITableViewCell()}
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        
        if let post = notification.post {
            let feedVC = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
            feedVC.post = post
            feedVC.viewSinglePost = true
            navigationController?.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(feedVC, animated: true)
        } else {
            let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileVC.user = notification.user
            navigationController?.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(userProfileVC, animated: true)
        }
    }
    
    // MARK: - Notification Delegate Protocols
    
    func handleFollowTapped(for cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            user.unfollow()
            
            cell.followButton.followStyle()
        } else {
            user.follow()
            
            cell.followButton.followingStyle()
        }
    }
    
    func handlePostTapped(for cell: NotificationCell) {
        guard let post = cell.notification?.post else { return }
        
        let feedVC = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.post = post
        feedVC.viewSinglePost = true
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
// MARK: - Handlers
    
    func handleReloadTable() {
        self.timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotifications), userInfo: nil, repeats: false)
    }
    
    @objc func handleSortNotifications() {
        self.notifications.sort { noti1, noti2 in
            return noti1.creationDate > noti2.creationDate
        }
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - API
    
    func fetchNotification(withNotificationId notificationId: String, dataSnapshot snapshot: DataSnapshot) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        guard
            let dictionary = snapshot.value as? [String: AnyObject],
            let uid = dictionary["uid"] as? String else { return }
        
        Database.fetchUser(with: uid) { user in
            
            // if notification for post
            if let postID = dictionary["postID"] as? String {
                Database.fetchPosts(with: postID) { post in
                    let notification = Notification(user: user, post: post, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                }
                // if notification for like
            } else {
                let notification = Notification(user: user, post: nil, dictionary: dictionary)
                self.notifications.append(notification)
                self.handleReloadTable()
            }
        }
        NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").setValue(1)
    }
    
    func fetchNotification() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if currentKey == nil {
            NOTIFICATIONS_REF.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value) { snapshot in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let notificationId = snapshot.key
                    self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                }
                self.currentKey = first.key
            }
        } else {
            NOTIFICATIONS_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value) { snapshot in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { snapshot in
                    let notificationId = snapshot.key
                    
                    if notificationId != self.currentKey {
                        self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                    }
                }
                self.currentKey = first.key
            }
        }
    }
}
