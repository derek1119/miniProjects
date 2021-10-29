//
//  CommentCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit

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
    
    let commentTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 12)
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(4)
            profileImageView.layer.cornerRadius = 40 / 2
        }
        
        addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(4)
            make.right.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handler
    func fetchUI() {
        guard
        let user = comment?.user,
        let profileImageURL = user.profileImageURL,
        let username = user.username,
        let commentText = comment?.commentText
        else { return }
        
        self.profileImageView.loadImage(with: profileImageURL)
        let attributedText = NSMutableAttributedString(string: "\(username)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " \(commentText)\n", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "2일 전", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        commentTextView.attributedText = attributedText

    }
    
}
