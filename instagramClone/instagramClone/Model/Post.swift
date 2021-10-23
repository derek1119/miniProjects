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
    var user: User?
    var didLike = false
    
    init(postID: String, user: User, dictionary: Dictionary<String, AnyObject>) {
        self.postID = postID
        
        self.user = user
        
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
    
    func adjustLikes(addLike: Bool, completion: @escaping (Int) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postID = self.postID else { return }
        
        if addLike {
            // update user-likes structure
            USER_LIKES_REF.child(currentUid).updateChildValues([postID: 1]) { err, ref in
                // update 포스트에 좋아요한 유저 업데이트
                POST_LIKES_REF.child(postID).updateChildValues([currentUid: 1]) { err, ref in
                    self.likes += 1
                    self.didLike = true
                    // 데이터베이스의 좋아요 개수 수정
                    POSTS_REF.child(postID).child("likes").setValue(self.likes)
                    completion(self.likes)
                }
            }
        } else {
            // update user-likes structure
            USER_LIKES_REF.child(currentUid).child(postID).removeValue { err, ref in
                // update 포스트에 좋아요한 유저 업데이트
                POST_LIKES_REF.child(postID).child(currentUid).removeValue { err, ref in
                    guard self.likes > 0 else { return }
                    self.likes -= 1
                    self.didLike = false
                    // 데이터베이스의 좋아요 개수 수정
                    POSTS_REF.child(postID).child("likes").setValue(self.likes)
                    completion(self.likes)
                }
            }
        }
        

        
    }
}
