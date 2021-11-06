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

extension UIButton {
    func followStyle() {
        self.setTitle("Follow", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0
        self.backgroundColor = .isEnableStateColor
    }
    
    func followingStyle() {
        self.setTitle("Following", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
    }
}

extension CGFloat {
    var windowWidth: Self {
        return UIScreen.main.bounds.width
    }
    
    var windowHeight: Self {
        return UIScreen.main.bounds.height
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

extension UIViewController {
    
    func getMentionUser(withUsername username: String) {
        
        USER_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            
            USER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                if username == dictionary["username"] as? String {
                    Database.fetchUser(with: uid) { user in
                        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
                        userProfileVC.user = user
                        self.navigationController?.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(userProfileVC, animated: true)
                        // 해쉬태그 된 user를 찾고 나서 불필요한 작업을 방지하는 방법 -> return
                        return
                    }
                }
            }
        }
    }
    
    func uploadMentionNotification(forPostId postId: String, withText text: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("@") {
                word = word.trimmingCharacters(in: .symbols)
                word = word.trimmingCharacters(in: .punctuationCharacters)
                
                USER_REF.observe(.childAdded) { snapshot in
                    let uid = snapshot.key
                    
                    USER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                        if word == dictionary["username"] as? String {
                            let notificationValues = ["postID": postId,
                                                      "uid": currentUID, "type": MENTION_INT_VALUE,
                                                            "creationDate": creationDate] as [String: Any]
                            if currentUID != uid {
                                NOTIFICATIONS_REF.child(uid).childByAutoId().updateChildValues(notificationValues)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UIColor {
    static let isUnableStateColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
    static let isEnableStateColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

