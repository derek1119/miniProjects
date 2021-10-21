//
//  FollowCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit

class FollowCell: UITableViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL,
                  let username = user?.username,
                  let fullName = user?.name
            else { return }
            
            profileImageView.loadImage(with: profileImageURL)
            
            self.textLabel?.text = username
            
            self.detailTextLabel?.text = fullName
            
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
        $0.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        $0.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
    }
    
    // MARK: - Handlers
    @objc func handleFollowTapped() {
        print(#function)
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
        
        
//        if #available(iOS 15.0, *) {
//            return
//        } else {
//            textLabel?.frame = CGRect(x: 60, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
//            textLabel?.font = .boldSystemFont(ofSize: 12)
//
//            detailTextLabel?.frame = CGRect(x: 60, y: (detailTextLabel?.frame.origin.y)! - 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
//            detailTextLabel?.font = .boldSystemFont(ofSize: 12)
//        }
    }
    /*
    func fetchUI() {
        
        self.textLabel?.text = "\(self.user?.username ?? "User Name")"
        self.textLabel?.font = .boldSystemFont(ofSize: 16)
        self.textLabel?.tintColor = .black
        self.detailTextLabel?.text = "\(self.user?.name ?? "Full Name")"
        self.detailTextLabel?.font = .systemFont(ofSize: 10, weight: .regular)
        self.detailTextLabel?.backgroundColor = .lightGray
        
        if #available(iOS 14.0, *) {
            var content = self.defaultContentConfiguration()
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 0)
            content.attributedText = NSAttributedString(string: "\(self.user?.username ?? "User Name")" , attributes: [ .font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black ])
            content.secondaryAttributedText = NSAttributedString(string: "\(self.user?.name ?? "Full Name")", attributes: [ .font: UIFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor: UIColor.lightGray ])
            self.contentConfiguration = content
        } else {
            // Fallback on earlier versions

        }
    }
     */
}
