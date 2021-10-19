//
//  UserProfileHeader.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/19.
//

import UIKit
import Then
import SnapKit

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    let postsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "게시물", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
    }
    
    let followersLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "팔로워", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
    }
    
    let followingLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "팔로잉", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        $0.attributedText = attributedText
    }
    
    lazy var userStatestackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let editProfileButton = UIButton(type: .system).then {
        $0.setTitle("프로필 편집", for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let gridButton = UIButton(type: .system).then {
        $0.setImage(Image("grid"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let listButton = UIButton(type: .system).then {
        $0.setImage(Image("list"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(Image("ribbon"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        addSubview(userStatestackView)
        
        userStatestackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(12)
            make.height.equalTo(50)
        }
        
        addSubview(editProfileButton)
        
        editProfileButton.snp.makeConstraints { make in
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
}
