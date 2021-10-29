//
//  NewMessageCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit

class NewMessageCell: UITableViewCell {

    // MARK: - Properties
    
    var user: User? {
        
        didSet {
            guard
                let profileImageURL = user?.profileImageURL,
                let username = user?.username,
                let fullname = user?.name else { return }
            
            profileImageView.loadImage(with: profileImageURL)
            textLabel?.text = username
            detailTextLabel?.text = fullname
        }
    }
    
    let profileImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(50)
            profileImageView.layer.cornerRadius = 50 / 2
            make.centerY.equalToSuperview()
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
    

}
