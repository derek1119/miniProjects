//
//  Post.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import Foundation

class Post {
    var caption: String!
    var likes: Int!
    var imageURL: String!
    var ownerUID: String!
    var creationDate: Date!
    var postID: String!
    
    init(postID: String, dictionary: Dictionary<String, AnyObject>) {
        self.postID = postID
        
        guard
            let caption = dictionary["caption"] as? String,
            let likes = dictionary["likes"] as? Int,
            let imageURL = dictionary["imageURL"] as? String,
            let ownerUID = dictionary["ownerUID"] as? String,
            let creationDate = dictionary["creationDate"] as? Double                    else { return }
        self.caption = caption
        self.likes = likes
        self.imageURL = imageURL
        self.ownerUID = ownerUID
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
    
}
