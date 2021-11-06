//
//  FeedCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import UIKit
import Firebase
import ActiveLabel

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    var delegate: FeedCellDelegate?
    
    var post : Post? {
        
        didSet {
            
            guard let ownerUID = post?.ownerUID,
                  let imageURL = post?.imageURL,
                  let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUID) { user in
                self.profileImageView.loadImage(with: user.profileImageURL)
                self.userNameButton.setTitle(user.username, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            postImageView.loadImage(with: imageURL)
            
            likesLabel.text = "좋아요 \(likes)개"
            configureLikeButton()
            
        }
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let userNameButton = UIButton(type: .system).then {
        $0.setTitle("Username", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(handleUserNameTapped), for: .touchUpInside)
    }
    
    let optionButton = UIButton(type: .system).then {
        $0.setTitle("•••", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(handleOptionsTapped), for: .touchUpInside)
    }
    
    lazy var postImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
        
        // add gesture recognizer for double tap to like
        let likeDoubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapToLike))
        likeDoubleTap.numberOfTapsRequired = 2
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(likeDoubleTap)
    }
    
    let likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("like_unselected"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    }
    
    let commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("comment"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
    }
    
    let messageButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("send2"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handleMessageTapped), for: .touchUpInside)
    }
    
    let savePostButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("ribbon"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handleSavePostTapped), for: .touchUpInside)
    }
    
    lazy var likesLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.text = "좋아요 0개"
        
        // 제스처 추가
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(likeTap)
    }
    
    let captionLabel = ActiveLabel().then {
        $0.numberOfLines = 0
    }
    
    let postTimelabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.text = "2일 전"
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // configure profile and post
        configurePostUI()
        
        // configure action button
        configureActionButton()
        
        configureCaption()
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    @objc func handleUserNameTapped() {
        delegate?.handleUserNameTapped(for: self)
    }
    
    @objc func handleOptionsTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleDoubleTapToLike() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: true)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: false)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleMessageTapped() {
        delegate?.handleMessageTapped(for: self)
    }
    
    @objc func handleSavePostTapped() {
        delegate?.handleSavePostTapped(for: self)
    }
    
    @objc func handleShowLikes() {
        delegate?.handleShowLikes(for: self)
    }
    
    func configureLikeButton() {
        delegate?.handleConfigureLikeButton(for: self)
    }
    
    // MARK: - Configurations
    
    func configurePostUI() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            profileImageView.layer.cornerRadius = 40 / 2
        }
        
        addSubview(userNameButton)
        userNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNameButton)
            make.right.equalToSuperview().offset(-8)
        }
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.frame.width)
        }
    }
    
    func configureActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        addSubview(likesLabel)
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(-4)
            make.left.equalToSuperview().offset(8)
        }
        
        addSubview(savePostButton)
        savePostButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackView)
            make.right.equalToSuperview().offset(-8)
            make.width.equalTo(20)
            make.height.equalTo(24)
        }
    }
    
    func configurePostCaption(user: User) {
        
        guard
            let post = post,
            let caption = post.caption,
            let username = user.username else { return }
        
        // look for username as pattern
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        // enable username as custom type
        captionLabel.enabledTypes = [.mention, .hashtag, .url, customType]
        
        //configure username link attributes
        captionLabel.configureLinkAttribute = { type, attributes, isSelected in
            var atts = attributes
            
            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize:12)
            default: ()
            }
            return atts
        }
        
        captionLabel.customize { label in
            label.text = "\(username) \(caption)"
            label.customColor[customType] = .black
            label.font = .systemFont(ofSize: 12)
            label.textColor = .black
            captionLabel.numberOfLines = 2
        }
        
        postTimelabel.text = "2일 전"
    }
    
    func configureCaption() {
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        addSubview(postTimelabel)
        postTimelabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(8)
            make.leading.equalTo(captionLabel)
        }
    }
}
