//
//  NotificationCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit

class NotificationCell: UITableViewCell {

    // MARK: - Properties
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let notificationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
        $0.numberOfLines = 2
        
        let attributedText = NSMutableAttributedString(string: "유저 이름", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " 알림 내용 댓글 달았어요 좋아요 눌렀어요.\n", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "2일 전", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
    }
    
    let followButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .isEnableStateColor
        $0.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
    }
    
    let postImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        print("noti cell에서 보내는 메세지: ", #function)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            profileImageView.layer.cornerRadius = 40 / 2
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        followButton.isHidden = true
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.width.right.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.bottom.equalToSuperview()
            if !followButton.isHidden {
                make.right.equalTo(followButton.snp.left).offset(8)
            } else {
                make.right.equalTo(postImageView.snp.left).offset(8)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
