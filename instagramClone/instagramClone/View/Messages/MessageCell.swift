//
//  MessageCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/28.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    
    // MARK: - Properties
    var message: Message? {
        
        didSet {
            
            guard let messageText = message?.messageText else { return }
            detailTextLabel?.text = messageText
            
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter().then {
                    $0.dateFormat = "hh:mm a"
                }
                timeStampLabel.text = dateFormatter.string(from: seconds)
            }
            
            configureUserData()
        }
        
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let timeStampLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .darkGray
        $0.text = "2시간 "
    }
    
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(50)
            profileImageView.layer.cornerRadius = 50 / 2
            make.centerY.equalToSuperview()
        }
        
        addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-12)
        }
        
        textLabel?.text = "유저 이름"
        detailTextLabel?.text = "메세지 내용"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y + 2, width: self.frame.width - 108, height: textLabel!.frame.height)
        
        textLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        detailTextLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    func configureUserData() {
        
        guard let chatPartnerId = message?.getChatPartnerId() else { return }
        Database.fetchUser(with: chatPartnerId) { user in
            self.profileImageView.loadImage(with: user.profileImageURL)
            self.textLabel?.text = user.username
        }
    }
}
