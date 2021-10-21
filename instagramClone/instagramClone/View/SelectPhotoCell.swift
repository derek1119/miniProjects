//
//  SelectPhotoCell.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit

class SelectPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .yellow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
