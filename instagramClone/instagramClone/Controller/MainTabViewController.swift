//
//  MainTabViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit
import Firebase

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    var isInitialLoad: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate
        delegate = self
        
        configureViewControllers()
        
        // user validation
        checkIfUserIsLogIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // 홈 피드 컨트롤러
        let feedVC = constructNavigationCotroller(unselectedImage: #imageLiteral(resourceName: "home_unselected") , selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        // 검색 피드 컨트롤러
        let searchVC = constructNavigationCotroller(unselectedImage: #imageLiteral(resourceName: "search_unselected") , selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchViewController())
        
        // 이미지 선택 컨트롤러
        let selectVC = constructNavigationCotroller(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        // 노티피케이션 컨트롤러
        let notificationVC = constructNavigationCotroller(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationViewController())
        
        // 프로필 컨트롤러
        let userProfileVC = constructNavigationCotroller(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // tab controller에 view controller 추가하기
        viewControllers = [feedVC, searchVC, selectVC, notificationVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGray6
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            let selectImageVC = SelectImageViewController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            navController.navigationBar.tintColor = .black
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    // 네비게이션 컨트롤러 생성
    // ---> 탭바 아이템의 선택된 이미지를 기준으로 루트뷰 컨트롤러를 변경하여 뷰를 표시
    func constructNavigationCotroller(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // 네비게이션 컨트롤러 설정
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        //return nav Controller
        return navController
    }
    
    func checkIfUserIsLogIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                // present login controller
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
}
