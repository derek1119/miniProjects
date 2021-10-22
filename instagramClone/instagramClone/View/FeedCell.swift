//
//  FeedCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let userNameButton = UIButton(type: .system).then {
        $0.setTitle("Username", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let optionButton = UIButton(type: .system).then {
        $0.setTitle("•••", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    let postImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
    }
    
    let likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("like_unselected"), for: .normal)
        $0.setImage(UIImage().Image("like_selected"), for: .selected)
        $0.tintColor = .black
    }
    
    let commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("comment"), for: .normal)
        $0.tintColor = .black
    }
    
    let messageButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("send2"), for: .normal)
        $0.tintColor = .black
    }
    
    let savePostButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("ribbon"), for: .normal)
        $0.tintColor = .black
    }
    
    let likesLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.text = "좋아요 3개"
    }
    
    let captionLabel = UILabel().then {
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        attributedText.append(NSAttributedString(string: " Some test caption for now", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        $0.attributedText = attributedText
    }
    
    let postTimelabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.text = "2일 전"
    }
    
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
