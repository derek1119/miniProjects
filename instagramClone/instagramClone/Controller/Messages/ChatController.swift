//
//  ChatController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit
import Firebase

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var user: User?
    var messages = [Message]()
    
    lazy var containerView = UIView().then { containerView in
        containerView.frame = CGRect(x: 0, y: 0, width: CGFloat().windowWidth, height: 55)
        
        let spacingLeadingView = UIView().then {
            $0.snp.makeConstraints { make in
                make.width.equalTo(8)
            }
        }
        
        let sendButton = UIButton(type: .system).then {
            $0.setTitle("보내기", for: .normal)
            $0.addTarget(self, action: #selector(self.handleSend), for: .touchUpInside)
        }
        
        let spacingTrailingView = UIView().then {
            $0.snp.makeConstraints { make in
                make.width.equalTo(8)
            }
        }
        
        lazy var stackView = UIStackView(arrangedSubviews: [spacingLeadingView, self.messageTextField, sendButton, spacingTrailingView]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.distribution = .fill
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let separatorView = UIView().then {
            $0.backgroundColor = .lightGray
        }
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    let messageTextField = UITextField().then {
        $0.placeholder = "메세지를 입력하세요."
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure navigation bar
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 , height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ChatCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleSend() {
        print(#function)
    }
    
    @objc func handleInfoTapped() {
        print(#function)
    }
    
    func configureNavigationBar() {
        guard let user = user else { return }
        
        navigationItem.title = user.username
        
        let infoButton = UIButton(type: .infoLight).then {
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
        }
        
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
}
