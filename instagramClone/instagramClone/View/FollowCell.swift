//
//  FollowCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit
import Firebase

class FollowCell: UITableViewCell {
    
    var delegate: FollowCellDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL,
                  let username = user?.username,
                  let fullName = user?.name
            else { return }
            
            profileImageView.loadImage(with: profileImageURL)
            
            self.textLabel?.text = username
            
            self.detailTextLabel?.text = fullName
            
            // hide follow button for current user
            if user?.uid == Auth.auth().currentUser?.uid {
                self.followButton.isHidden = true
            }
            
            user?.checkIfUserIsFollowed(completion: { followed in
                if followed {
                    // configure follow button for followed user
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.setTitleColor(.black, for: .normal)
                    self.followButton.layer.borderWidth = 0.5
                    self.followButton.layer.borderColor = UIColor.lightGray.cgColor
                    self.followButton.backgroundColor = .white
                } else {
                    // configure follow button for none followed user
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.layer.borderWidth = 0
                    self.followButton.backgroundColor = .isEnableStateColor

                }
            })
        }
    }

    // MARK: - Properties
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    lazy var followButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .isEnableStateColor
        $0.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
    }
    
    // MARK: - Handlers
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
            profileImageView.layer.cornerRadius = 48 / 2
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        textLabel?.text = "Username"
        
        detailTextLabel?.text = "Full name"
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = .boldSystemFont(ofSize: 12)
        
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)!, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = .boldSystemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
 
    }

}
