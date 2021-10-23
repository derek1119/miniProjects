//
//  User.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/19.
//

import Firebase

class User {
    // attributes
    var username: String!
    var name: String!
    var profileImageURL: String!
    var uid: String!
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if  let username = dictionary["username"] as? String,
            let name = dictionary["name"] as? String,
            let profileImageURL = dictionary["profileImageURL"] as? String {
            self.username = username
            self.name = name
            self.profileImageURL = profileImageURL
        }
    }
    
    func follow() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        // UPDATE: - get uid like this to work with update
        guard let uid = uid else { return }
        
        // set is followed to true
        self.isFollowed = true
        
        // add followed user to current user-following structure
        USER_FOLLOWING_REF.child(currentUID).updateChildValues([uid: 1])
        
        // add current user to followed user-follower structure
        USER_FOLLOWER_REF.child(uid).updateChildValues([currentUID: 1])
        
        // add followed uwers posts to current user feed
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { snapshot in
            let postId = snapshot.key
            USER_FEED_REF.child(currentUID).updateChildValues([postId: 1])
        }

    }
    
    func unfollow() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        // UPDATE: - get uid like this to work with update
        guard let uid = uid else { return }
        
        self.isFollowed = false
        
        USER_FOLLOWING_REF.child(currentUID).child(uid).removeValue()
        
        USER_FOLLOWER_REF.child(uid).child(currentUID).removeValue()
        
        // remove unfollowed users posts from current user-feed
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { snapshot in
            let postId = snapshot.key
            USER_FEED_REF.child(currentUID).child(postId).removeValue()
        }
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }

        USER_FOLLOWING_REF.child(currentUID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(self.uid) {
                self.isFollowed = true
                completion(true)
            } else {
                self.isFollowed = false
                completion(false)
            }
        }
    }
    
//    func uploadFollowNotificationToServer() {
//        guard let currentUID = Auth.auth().currentUser?.uid else { return }
//        let creationDate = Int(NSDate().timeIntervalSince1970)
//
//        // notification values
//        let values = ["checked": 0,
//                      "creationDate": creationDate,
//                      "uid": currentUID,
//                      "type": FOLLOW_INT_VALUE] as [String : Any]
//
//        NOTIFICATIONS_REF.child(self.uid).childByAutoId().updateChildValues(values)
//    }
}
