//
//  Notification.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/27.
//

import Foundation

class Notification {
    
    enum NotificationType: Int, Printable {
        
        case Like = 0
        case Comment
        case Follow
        case Mention
        
        var description: String {
            switch self {
            case .Like:
                return "회원님의 게시물을 좋아합니다."
            case .Comment:
                return "댓글을 달았습니다."
            case .Follow:
                return "회원님을 팔로우하기 시작했습니다."
            case .Mention:
                return "회원님을 언급하였습니다."
            }
        }
    }
    
    var creationDate: Date!
    var uid: String!
    var postID: String?
    var post: Post?
    var user: User!
    var notificationType: NotificationType!
    var didCheck = false
    
    init(user: User, post: Post? = nil, dictionary: Dictionary<String, AnyObject>) {
        self.user = user
        if let post = post {
            self.post = post
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let type = dictionary["type"] as? Int {
            self.notificationType = NotificationType(rawValue: type)
        }
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        
        if let postID = dictionary["postID"] as? String {
            self.postID = postID
        }
        
        if let checked = dictionary["checked"] as? Int {
            if checked == 0 {
                self.didCheck = false
            } else {
                self.didCheck = true
            }
        }
    }
    
}
