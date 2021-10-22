//
//  UserPostCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/22.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {

            guard let imageURL = post?.imageURL else { return }
            postImageView.loadImage(with: imageURL)
        }
    }
    
    // MARK: - Properties
    let postImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
