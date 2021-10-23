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
        if addLike {
            likes += 1
            didLike = true
        } else {
            guard likes > 0 else { return }
            likes -= 1
            didLike = false
        }
        
       print("포스트 모델에서 호출")
        // 데이터베이스의 좋아요 개수 수정
        POSTS_REF.child(postID).child("likes").setValue(likes)
    }
}
