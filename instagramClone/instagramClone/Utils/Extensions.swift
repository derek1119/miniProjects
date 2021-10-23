//
//  Extensions.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/12.
//

import UIKit
import SnapKit
import Firebase

extension UIView {
    
    var safeArea: ConstraintBasicAttributesDSL {
#if swift(>=3.2)
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
#else
        return self.snp
#endif
    }
    
}

extension UIApplication {
    static let KeyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
}

extension UIImage {
    func Image(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }
}




extension Database {
    static func fetchUser(with uid: String, completion: @escaping (User) -> Void) {
        USER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchPosts(with postId: String, completion: @escaping(Post) -> Void) {
        POSTS_REF.child(postId).observeSingleEvent(of: .value) { snapshot in

            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUID"] as? String else { return }
            
            Database.fetchUser(with: ownerUid) { user in
                let post = Post(postID: postId, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
}

extension UIColor {
    static let isUnableStateColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
    static let isEnableStateColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
}
