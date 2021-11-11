//
//  UploadPostViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    
    enum UploadAction {
        case uploadPost
        case saveChanges
        
        init() {
            self = .uploadPost
        }
    }

    var uploadAction = UploadAction()
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    var postToEdit: Post?
    let loadingVC = LoadingViewController()
    
    let photoImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let captionTextView = UITextView().then {
        $0.backgroundColor = UIColor.systemGroupedBackground
        $0.font = .systemFont(ofSize: 12)
        
    }
    
    let actionButton = UIButton(type: .system).then {
        $0.backgroundColor = .isUnableStateColor
        $0.setTitle("Share", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textview delegate
        captionTextView.delegate = self
        
        // background color
        view.backgroundColor = .white
        
        // configure UI
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch uploadAction {
        case .uploadPost:
            actionButton.setTitle("share", for: .normal)
            navigationItem.title = "게시물 올리기"

        case .saveChanges:
            guard let postToEdit = postToEdit else { return }
            actionButton.setTitle("Save Changes", for: .normal)
            navigationItem.title = "게시물 수정"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleCancel))
            navigationController?.navigationBar.tintColor = .black
            photoImageView.loadImage(with: postToEdit.imageURL)
            captionTextView.text = postToEdit.caption
        }
    }
    
    // MARK: - UITextView
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else {
            actionButton.isEnabled = false
            actionButton.backgroundColor = .isUnableStateColor
            return }
        actionButton.isEnabled = true
        actionButton.backgroundColor = .isEnableStateColor
    }
    
    // MARK: - handlers
    
    func updateUserFeed(with postID: String) {
        
        // current user id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // database values
        let values = [postID: 1]
        
        // update followers feeds
        USER_FOLLOWER_REF.child(currentUid).observe(.childAdded) { snapshot in
            let followerUid = snapshot.key
            USER_FEED_REF.child(followerUid).updateChildValues(values)
        }
        
        // update current user feed
        USER_FEED_REF.child(currentUid).updateChildValues(values)
    }
    
    @objc func handleUploadAction() {
        buttonSelector(uploadAction: uploadAction)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonSelector(uploadAction: UploadAction) {
        switch uploadAction {
        case .uploadPost:
            handleUploadPost()
            
        case .saveChanges:
            handleSavePostChanges()
            
        }
    }
    
    func handleSavePostChanges() {
        guard
            let postToEdit = postToEdit,
            let updatedCaption = captionTextView.text else { return }
        
        uploadHashtagToServer(withPostId: postToEdit.postID)
        
        POSTS_REF.child(postToEdit.postID).child("caption").setValue(updatedCaption) { err, ref in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleUploadPost() {
        self.loadingVC.modalPresentationStyle = .overCurrentContext
        self.loadingVC.modalTransitionStyle = .crossDissolve
        
        self.present(self.loadingVC, animated: true, completion: nil)
        
        // paramaters
        guard
            let caption = captionTextView.text,
            let postImage = photoImageView.image,
            let currentUID = Auth.auth().currentUser?.uid else { return }
        
        // image upload data
        guard let uploadData = postImage.jpegData(compressionQuality: 0.5) else { return }
        
        // creation Date
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // update storage
        let filename = NSUUID().uuidString
        let storatyRef = STORAGE_REF.child("post_images").child(filename)
        
        storatyRef.putData(uploadData, metadata: nil) { metadata, error in
            
            // handle error
            if let error = error {
                print("이미지 저장하는데 오류 :", error.localizedDescription)
                return
            }
            
            // image url
            storatyRef.downloadURL(completion: { url, error in
                if let error = error {
                    print("post image download url 생성 실패 :", error.localizedDescription)
                    return
                }
                guard let postImageURL = url?.absoluteString else {
                    print("url 생성 실패")
                    return }
                
                // post data
                let values = ["caption": caption,
                              "creationDate": creationDate,
                              "likes": 0,
                              "imageURL": postImageURL,
                              "ownerUID": currentUID] as [String: Any]
                
                // post id
                let postID = POSTS_REF.childByAutoId()
                
                guard let postId = postID.key else { return }
                // upload information to database
                postID.updateChildValues(values) { err, ref in
                    
                    // update user-post structure
                    let userPostsRef = USER_POSTS_REF.child(currentUID)
                    userPostsRef.updateChildValues([postId: 1])
                    
                    // update user-feed structure
                    self.updateUserFeed(with: postId)
                    
                    // upload hashtag to server
                    self.uploadHashtagToServer(withPostId: postId)
                    
                    // upload mention noti
                    if caption.contains("@") {
                        self.uploadMentionNotification(forPostId: postId, withText: caption, isForComment: false)
                    }
                    
                    self.loadingVC.dismiss(animated: true)
                    // return to home feed
                    self.dismiss(animated: true) {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            })
        }
    }
    
    func configureUI() {
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.top)
            make.leading.equalTo(photoImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(100)
        }
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - API
    
    func uploadHashtagToServer(withPostId PostID: String) {
        
        guard let caption = captionTextView.text else { return }
        
        let words: [String] = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                let hashtagValues = [PostID: 1]
                
                HASHTAG_POST_REF.child(word.lowercased()).updateChildValues(hashtagValues)
            }
        }
    }
}
