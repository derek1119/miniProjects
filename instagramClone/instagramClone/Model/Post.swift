//
//  Post.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import Foundation
import Firebase

class Post {
    var caption: String!
    var likes: Int!
    var imageURL: String!
    var ownerUID: String!
    var creationDate: Date!
    var postID: String!
    var didLike = false
    
    init(postID: String, dictionary: Dictionary<String, AnyObject>) {
        self.postID = postID
        
        guard
            let caption = dictionary["caption"] as? String,
            let likes = dictionary["likes"] as? Int,
            let imageURL = dictionary["imageURL"] as? String,
            let ownerUID = dictionary["ownerUID"] as? String,
            let creationDate = dictionary["creationDate"] as? Double else { return }
        self.caption = caption
        self.likes = likes
        self.imageURL = imageURL
        self.ownerUID = ownerUID
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
    
    func adjustLikes(addLike: Bool) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if addLike {
            // update user-likes structure
            USER_LIKES_REF.child(currentUid).updateChildValues([postID: 1]) { err, ref in
                // update 포스트에 좋아요한 유저 업데이트
                POST_LIKES_REF.child(self.postID).updateChildValues([currentUid: 1]) { err, ref in
                    self.likes += 1
                    self.didLike = true
                    // 데이터베이스의 좋아요 개수 수정
                    POSTS_REF.child(self.postID).child("likes").setValue(self.likes)
                    print("좋아요 수는? \(self.likes)")
                }
            }
        } else {
            // update user-likes structure
            USER_LIKES_REF.child(currentUid).child(postID).removeValue { err, ref in
                // update 포스트에 좋아요한 유저 업데이트
                POST_LIKES_REF.child(self.postID).child(currentUid).removeValue { err, ref in
                    guard self.likes > 0 else { return }
                    self.likes -= 1
                    self.didLike = false
                    // 데이터베이스의 좋아요 개수 수정
                    POSTS_REF.child(self.postID).child("likes").setValue(self.likes)
                    print("좋아요 수는? \(self.likes)")
                }
            }
        }
        

        
    }
}
