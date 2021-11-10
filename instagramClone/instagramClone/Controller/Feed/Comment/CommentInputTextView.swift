//
//  CommentInputTextView.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/09.
//

import UIKit

class CommentInputTextView: UITextView {
    
    // MARK: - Properties
    
    let placeholderLabel = UILabel().then { label in
        label.text = "댓글 달기..."
        label.textColor = .lightGray
    }
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    @objc func handleInputTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
