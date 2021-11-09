//
//  CommentInputTextView.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/09.
//

import UIKit

class CommentInputTextView: UITextView {
    
    let placeholderLabel = UILabel().then { label in
        label.text = "댓글을 입력해주세요."
        label.textColor = .lightGray
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
