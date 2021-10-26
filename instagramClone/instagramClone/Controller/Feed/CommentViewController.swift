//
//  CommentViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCell"

class CommentViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var comments = [Comment]()
    var postId: String?
    
    lazy var containerView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        $0.backgroundColor = .white
        
        $0.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        $0.addSubview(commentTextField)
        commentTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(postButton.snp.left).offset(8)
            make.left.equalToSuperview().offset(15)
        }
        
        let separatorView = UIView().then {
            $0.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        }
        $0.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요."
        $0.font = .systemFont(ofSize: 14)
    }
    
    let postButton = UIButton(type: .system).then {
        $0.setTitle("Post", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(handleUploadComment), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure collectionview
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        // navigation title
        navigationItem.title = "댓글"
        
        // register cell class
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // fetch Comments
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - UICollectionView

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40+8+8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
        let comment = comments[indexPath.item]
        cell.comment = comment
        
        
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleUploadComment() {
        guard
            let postId = postId,
        let commentText = commentTextField.text,
        let uid = Auth.auth().currentUser?.uid
        else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let values = ["commentText" : commentText,
                      "creationDate" : creationDate,
                      "uid" : uid] as [String: Any]
        
        COMMENT_REF.child(postId).childByAutoId().updateChildValues(values) { err, ref in
            self.commentTextField.text = nil
        }
    }
    
    func fetchComments() {
        guard let postId = postId else { return }

        COMMENT_REF.child(postId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid) { user in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
        }
    }
}
