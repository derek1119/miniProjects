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
                
        containerView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            
        }
        
        containerView.addSubview(messageTextField)
        messageTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(sendButton.snp.left).offset(-8)
            make.left.equalToSuperview().offset(15)
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
    
    let sendButton = UIButton(type: .system).then {
        $0.setTitle("보내기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure navigation bar
        configureNavigationBar()
        
        observeMessages()
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
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ChatCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleSend() {
        uploadMessageToServer()
        
        messageTextField.text = nil
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
    
    // MARK: - API
    func uploadMessageToServer() {
        
        guard
            let messageText = messageTextField.text,
            let currentUid = Auth.auth().currentUser?.uid,
            let user = user,
            let uid = user.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let messageValue = ["creationDate": creationDate,
                            "fromID": currentUid,
                            "toID": uid,
                            "messageText": messageText] as [String: AnyObject]
        
        let messageRef = MESSAGES_REF.childByAutoId()
        guard let messageKey = messageRef.key else { return }
        
        messageRef.updateChildValues(messageValue) { err, ref in
            USER_MESSAGES_REF.child(currentUid).child(uid).updateChildValues([messageKey: 1])
            USER_MESSAGES_REF.child(uid).child(currentUid).updateChildValues([messageKey: 1])
        }
    }
    
    func observeMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerID = self.user?.uid else { return }
        
        USER_MESSAGES_REF.child(currentUid).child(chatPartnerID).observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            
            self.fetchMessage(withMessageId: messageId)
            
            
        }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView.reloadData()
        }
    }
}
