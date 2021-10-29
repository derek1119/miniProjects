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
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ChatCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    // MARK: - Handlers
    
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
