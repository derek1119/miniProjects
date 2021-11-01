//
//  ChatCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit
import Firebase
import SnapKit

class ChatCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var bubbleViewRightContraint: Constraint?
    var bubbleViewLeftContraint: Constraint?
    var bubbleViewWidthContraint: Constraint?
    
    let bubbleView = UIView().then {
        $0.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    var message: Message? {
        didSet {
            
            guard let messageText = message?.messageText else { return }
            textView.text = messageText
            
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
        $0.isEditable = true
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
                
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.width.height.equalTo(32)
            profileImageView.layer.cornerRadius = 32 / 2
        }
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
//            make.width.equalTo(200)
            make.height.equalToSuperview()
            
            self.bubbleViewRightContraint = make.right.equalToSuperview().offset(-8).constraint
            self.bubbleViewLeftContraint =             make.left.equalTo(profileImageView.snp.right).offset(8).constraint
            self.bubbleViewWidthContraint = make.width.equalTo(200).constraint
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(bubbleView).offset(8)
            make.top.equalToSuperview().offset(8)
            make.right.equalTo(bubbleView.snp.right).offset(-8)
            make.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
