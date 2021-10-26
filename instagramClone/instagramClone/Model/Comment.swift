//
//  Comment.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import Foundation
import Firebase

class Comment {
    var uid: String!
    var commentText: String!
    var creationDate: Date!
    var user: User?
    
    init(user: User, dictionary: Dictionary<String, AnyObject>) {
        self.user = user
        guard
            let uid = dictionary["uid"] as? String,
            let commentText = dictionary["commentText"] as? String,
            let creationDate = dictionary["creationDate"] as? Double
        else { return }
        self.uid = uid
        self.commentText = commentText
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
}
