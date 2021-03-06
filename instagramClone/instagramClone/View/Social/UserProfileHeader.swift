//
//  UserProfileHeader.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/19.
//

import UIKit
import Then
import SnapKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate : UserProfileHeaderDelegate?
    
    var  user: User? {
        didSet {
            // configure edit profile follow button
            configureEditProfileFollowButton()
            
            // set user stats
            setUserStats()
            
            let fullName = user?.name
            nameLabel.text = fullName
            guard let profileImageURL = user?.profileImageURL else { return }
            
            profileImageView.loadImage(with: profileImageURL)
        }
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    let postsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "게시물", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
    }
    
    lazy var followersLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "팔로워", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(followTap)
    }
    
    lazy var followingLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "팔로잉", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
        
        let followingTap = UITapGestureRecognizer(
            target: self, action: #selector(handleFollowingTapped))
        followingTap.numberOfTapsRequired = 1
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(followingTap)
    }
    
    lazy var userStatsStackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let editProfileFollowButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
    }
    
    let gridButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("grid"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let listButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("list"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage().Image("ribbon"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    private func setUpUI() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(80)
            profileImageView.layer.cornerRadius = 80 / 2
        }
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.centerX.equalTo(profileImageView)
        }
        
        addSubview(userStatsStackView)
        
        userStatsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(12)
            make.height.equalTo(50)
        }
        
        addSubview(editProfileFollowButton)
        
        editProfileFollowButton.snp.makeConstraints { make in
            make.top.equalTo(postsLabel.snp.bottom).offset(12)
            make.left.equalTo(postsLabel).offset(8)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(30)
        }
        
        configureBottomToolBar()
    }
    
    func configureBottomToolBar() {
        let topDividerView = UIView().then {
            $0.backgroundColor = .lightGray
        }
        
        let bottomDividerView = UIView().then {
            $0.backgroundColor = .lightGray
        }
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topDividerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.top)
            make.height.equalTo(0.5)
        }
        
        bottomDividerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Handler

    @objc func handleEditProfileFollow() {
        delegate?.handleEditFollowTapped(for: self)
    }
    
    @objc func handleFollowersTapped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
    func setUserStats() {
        delegate?.setUserStats(for: self)
    }
    
    func configureEditProfileFollowButton() {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        guard let user = user else { return }
        
        if currentUID == user.uid {
            
            // configure button as edit profile button
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            
        } else {
            
            // configure button as follow button
            editProfileFollowButton.setTitleColor(.white, for: .normal)
            editProfileFollowButton.backgroundColor = .isEnableStateColor
            
            user.checkIfUserIsFollowed(completion: { followed in
                if followed {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                } else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            })
        }

        
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
