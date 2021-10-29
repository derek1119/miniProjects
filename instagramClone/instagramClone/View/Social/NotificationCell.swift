//
//  NotificationCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/26.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    var delegate: NotificationCellDelegate?
    
    var notification: Notification? {
        
        didSet {
            
            guard
                let user = notification?.user,
                let profileImageURL = user.profileImageURL else { return }
            
            // configure notification label
            configureNotificationLabel()
            
            // configure notification type
            configureNotificationType()
            
            self.profileImageView.loadImage(with: profileImageURL)
            
        }
        
    }
    
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
    }
    
    let followButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .isEnableStateColor
        $0.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
    }
    
    lazy var postImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        tabGesture.numberOfTapsRequired = 1
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tabGesture)
    }
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc func handlePostTapped() {
        delegate?.handlePostTapped(for: self)
    }
    
    func configureNotificationLabel() {
        guard
            let notification = notification,
            let user = notification.user,
            let username = user.username,
            let notificationTime = getNotificationTimeStamp() else { return }
        
        let notificationMessage = notification.notificationType.description
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "님이 \(notificationMessage)\n", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "\(notificationTime) 전", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        notificationLabel.attributedText = attributedText
    }
    
    func configureNotificationType() {
        
        guard let notification = notification else { return }
        guard let user = notification.user else { return }

        switch notification.notificationType {
        case .Comment, .Like:
            followButton.isHidden = true
            postImageView.isHidden = false
            guard let post = notification.post else { return }
            postImageView.loadImage(with: post.imageURL)
        case .Follow:
            postImageView.isHidden = true
            followButton.isHidden = false
            user.checkIfUserIsFollowed { followed in
                if followed {
                    // configure follow button for followed user
                    self.followButton.followingStyle()
                } else {
                    // configure follow button for none followed user
                    self.followButton.followStyle()
                }
            }
        case .none:
            return
        }
        
    }
    
    func getNotificationTimeStamp() -> String? {
        
        guard let notification = notification else {
            return nil
        }
        let dateFormatter = DateComponentsFormatter().then {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_kr")
            $0.calendar = calendar
            $0.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
            $0.maximumUnitCount = 1
            $0.unitsStyle = .abbreviated
        }
        let now = Date()
        let dateToString = dateFormatter.string(from: notification.creationDate, to: now)
        
        return dateToString
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            profileImageView.layer.cornerRadius = 40 / 2
        }
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.bottom.equalToSuperview()
            if notification?.notificationType == .Follow {
                make.right.equalTo(contentView.snp.right).offset(100)
            } else {
                make.right.equalTo(postImageView.snp.left).offset(8)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
