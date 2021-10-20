//
//  SeachUserTableViewCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/20.
//

import UIKit

class SeachUserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add profile image view
        addSubview(profileImageView)
        
        if #available(iOS 14.0, *) {
            var content = self.defaultContentConfiguration()
            profileImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(8)
                make.width.height.equalTo(48)
                make.centerY.equalToSuperview()
                profileImageView.layer.cornerRadius = 48 / 2
                profileImageView.clipsToBounds = true
            }
            content.image = profileImageView.image
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 0)
            content.attributedText = NSAttributedString(string: "User Name", attributes: [ .font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black ])
            content.secondaryAttributedText = NSAttributedString(string: "Full Name", attributes: [ .font: UIFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor: UIColor.lightGray ])
            self.contentConfiguration = content
        } else {
            // Fallback on earlier versions
            self.textLabel?.text = "User Name"
            self.detailTextLabel?.text = "Full Name"
            profileImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(8)
                make.width.height.equalTo(48)
                make.centerY.equalToSuperview()
                profileImageView.layer.cornerRadius = 48 / 2
                profileImageView.clipsToBounds = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 15.0, *) {
            return
        } else {
            textLabel?.frame = CGRect(x: 60, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
            textLabel?.font = .boldSystemFont(ofSize: 12)
            
            detailTextLabel?.frame = CGRect(x: 60, y: (detailTextLabel?.frame.origin.y)! - 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
            detailTextLabel?.font = .boldSystemFont(ofSize: 12)
        }
    }
}
