//
//  FeedViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedViewController: UICollectionViewController {

    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()



        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        //configure logout button
        configureLogOutButton()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: - Handlers
    
    func configureLogOutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        
        // declare alert controller
        let alerController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 로그아웃 액션 추가
        alerController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            do {
                // 로그아웃 시도
                try Auth.auth().signOut()
                
                // present login controller
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                print("로그아웃 성공")
            } catch {
                // 에러 처리
                print("로그아웃 실패 ", error.localizedDescription)
            }
        }))
        
        // 취소 액션 추가
        alerController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alerController, animated: true, completion: nil)
    }
}
