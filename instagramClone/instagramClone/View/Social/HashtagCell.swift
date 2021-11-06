//
//  HashtagCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/06.
//

import UIKit

class HashtagCell: UICollectionViewCell {

    // MARK: - Properties
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageURL else { return }
            postImageView.loadImage(with: imageURL)
        }
    }
    
    let postImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
