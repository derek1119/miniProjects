//
//  Message.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import Foundation

class Message {
    
    var messageText: String!
    var fromID: String!
    var toID: String!
    var creationDate: Date!
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        guard
            let messageText = dictionary["messageText"] as? String,
            let fromID = dictionary["fromID"] as? String,
            let toID = dictionary["toID"] as? String,
            let creationDate = dictionary["creationDate"] as? Double else { return }
        
        self.messageText = messageText
        self.fromID = fromID
        self.toID = toID
        self.creationDate = Date(timeIntervalSince1970: creationDate)
    }
}
