//
//  CommentCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit
import ActiveLabel

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties

    var comment: Comment? {
        didSet {
            fetchUI()
        }
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let commentLabel = ActiveLabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = 0
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            profileImageView.layer.cornerRadius = 40 / 2
        }
        
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handler
    
    func configureCommentLabel() {
        guard
            let user = comment?.user,
            let comment = comment,
            let username = user.username,
            let commentText = comment.commentText
        else { return }
        
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        commentLabel.enabledTypes = [.hashtag, .mention, .url, customType]
        
        commentLabel.configureLinkAttribute = { type, attributes, isSelected in
            
            var atts = attributes
            
            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
            default: ()
            }
            return atts
        }
        
        commentLabel.customize { label in
            label.text = "\(username) \(commentText)"
            label.customColor[customType] = .black
            label.font = .systemFont(ofSize: 12)
            label.textColor = .black
            label.numberOfLines = 0
        }
    }
    
    func fetchUI() {
        guard
        let user = comment?.user,
        let profileImageURL = user.profileImageURL
        else { return }
        
        self.profileImageView.loadImage(with: profileImageURL)
        self.configureCommentLabel()
    }
}
