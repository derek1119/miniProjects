//
//  ChatCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit
import Firebase
import SnapKit

class ChatMyCell: UICollectionViewCell {
    
    // MARK: - Properties
    var isFirstMessage: Bool = false
    
    let bubbleView = UIView().then {
        $0.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    let nickNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    var message: Message? {
        didSet {
            
            guard let messageText = message?.messageText else { return }
            textView.text = messageText
            nickNameLabel.text = message?.fromID
            
            guard let chatPartnerId = message?.getChatPartnerId() else { return }
            Database.fetchUser(with: chatPartnerId) { user in
                guard let profileImageURL = user.profileImageURL else { return }
                self.profileImageView.loadImage(with: profileImageURL)
            }
        }
    }
    
    let textView = UITextView().then {
        $0.text = "Sample text fore now"
        $0.font = .systemFont(ofSize: 16)
//        $0.isEditable = true
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        [profileImageView, nickNameLabel, bubbleView, textView].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(32)
            profileImageView.layer.cornerRadius = 32 / 2
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalTo(profileImageView.snp.left).offset(-8)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.greaterThanOrEqualToSuperview().offset(64)
            make.right.equalTo(profileImageView.snp.left).offset(-8)
        }
        
        bubbleView.snp.makeConstraints { make in
            make.left.equalTo(textView).offset(-8)
            make.top.equalTo(textView).offset(-8)
            make.right.equalTo(textView).offset(8)
            make.bottom.equalTo(textView).offset(8)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
