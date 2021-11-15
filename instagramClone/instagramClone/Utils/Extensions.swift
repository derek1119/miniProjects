//
//  Extensions.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/12.
//

import Foundation
import UIKit
import SnapKit
import Firebase
import Toast_Swift

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
            return self.safeAreaLayoutGuide.snp
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
    
    func showToast(message: String, font: UIFont = .systemFont(ofSize: 14.0), _ superView: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: superView.frame.size.width/2 - 75, y: superView.frame.size.height - 130, width: 150, height: 35)).then { label in
            label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            label.textColor = UIColor.white
            label.font = font
            label.textAlignment = .center
            label.text = message
            label.alpha = 1.0
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
        }
        
        superView.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }
    }
    
    func uploadMentionNotification(forPostId postId: String, withText text: String, isForComment: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        let mentionIntegerValue = isForComment ? COMMENT_INT_VALUE : POST_MENTION_INT_VALUE
        
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
                                                      "uid": currentUID, "type": mentionIntegerValue,
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

extension Date {
    
    func timeAgoToDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        var quotient: Int?
        var unit: String
        
        switch secondsAgo {
        case ..<30:
            unit = "방금"
        case 30..<minute:
            quotient = secondsAgo
            unit = "초"
        case minute..<hour:
            quotient = secondsAgo / minute
            unit = "분"
        case hour..<day:
            quotient = secondsAgo / hour
            unit = "시"
        case day..<week:
            quotient = secondsAgo / day
            unit = "일"
        case week..<month:
            quotient = secondsAgo / week
            unit = "주"
        case month... :
            quotient = secondsAgo / month
            unit = "개월"
        default:
            return ""
        }
        
        if let quotient = quotient {
            return "\(quotient)\(unit) 전"
        } else {
            return "\(unit) 전"
        }
    }
    
}

extension Notification.Name {
    static let fetchNewData = Notification.Name("fetchNewData")
}

extension UICollectionViewCell: ReusableView {
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)") }
        return cell
    }
}

extension UITableViewCell: ReusableView {
}

extension UITableView {
    func register<T: UITableViewCell>(_ :T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)") }
        return cell
    }
}
