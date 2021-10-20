//
//  UserProfileViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    

    // MARK: - Properties
    
    var currentUser: User?
    var userToLoadFromSearchVC: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // background color
        self.collectionView.backgroundColor = .white
        
        // fetch user data
        if userToLoadFromSearchVC == nil {
            fetchCurrentUserData()
        }
        
    }

    // MARK: UICollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
     
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        header.delegate = self
        
        // set the user in header
        if let currentUser = currentUser {
            header.user = currentUser
        } else if let userToLoadFromSearchVC = userToLoadFromSearchVC {
            header.user = userToLoadFromSearchVC
            navigationItem.title = userToLoadFromSearchVC.username
        }
        
        // return header
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    // MARK: - API
    func fetchCurrentUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dic = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dic)
            self.currentUser = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UserProfileHeader
    func handleEditFollowTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }
    }
}
