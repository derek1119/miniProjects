//
//  CommentInputAccessoryView.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/11/09.
//

import UIKit

class CommentInputAccessoryView: UIView {

    // MARK: - Properties
    
    let commentTextView = CommentInputTextView().then {
        $0.font = .systemFont(ofSize: 16)
        $0.isScrollEnabled = false
    }
    
    let postButton = UIButton(type: .system).then {
        $0.setTitle("Post", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(handleUploadComment), for: .touchUpInside)
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(postButton.snp.left).offset(-8)
            make.left.equalToSuperview().offset(15)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 본질적인 콘텐츠의 크기 -> hugging과 resistance 때문에 더 복잡해 질 수 있다.
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Handlers
    
    @objc func handleUploadComment() {
        
    }
}
