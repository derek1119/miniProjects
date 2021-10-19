//
//  User.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/19.
//

class User {
    // attributes
    var username: String!
    var name: String!
    var profileImageURL: String!
    var uid: String!
    
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
}
