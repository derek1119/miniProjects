//
//  ChatController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/29.
//

import UIKit
import Firebase

class ChatController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var user: User?
    var messages = [Message]()
    var collectionView: UICollectionView!
    
    lazy var containerView = UIView().then { containerView in
        containerView.frame = CGRect(x: 0, y: 0, width: CGFloat().windowWidth, height: 55)
                
        containerView.backgroundColor = .white
        
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
        
        self.view.backgroundColor = .white
        
        configureCollectionView()
   
        // configure navigation bar
        configureNavigationBar()
        
        observeMessages()
        
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - UICollectionView
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: CGFloat().windowWidth, height: 100)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatMyCell.self)
    }
    
    func configureUI() {
        [collectionView, containerView].forEach { self.view.addSubview($0) }
        containerView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(containerView.snp.top)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.row].messageText
        height = estimateFrameForText(message).height + 20
        
        return CGSize(width: view.frame.width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChatMyCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let message = messages[indexPath.item]
        cell.message = message
        if indexPath.item > 0 {
            let prevMessageId = messages[indexPath.item - 1].fromID
            let isFirstMessage = prevMessageId != message.fromID
            configureMessage(cell: cell, message: message, isFirstMessage: isFirstMessage)
        } else {
            configureMessage(cell: cell, message: message, isFirstMessage: true)
        }
        
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleSend() {
        uploadMessageToServer()
        
        messageTextField.text = nil
    }
    
    @objc func handleInfoTapped() {
        let userProfileVC = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // text의 Rect을 구하는 방법
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func configureMessage(cell: ChatMyCell, message: Message, isFirstMessage: Bool) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        if message.fromID == currentUid {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
            cell.textView.textColor = .white
            
        } else {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
        }
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
            let lastIndexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.insertItems(at: [lastIndexPath])
        }
    }
}
