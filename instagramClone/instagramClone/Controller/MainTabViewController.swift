//
//  MainTabViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/18.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // 홈 피드 컨트롤러
        configureNavigationCotroller(unselectedImage:  UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedViewController())
        // 검색 피드 컨트롤러
        
        // 포스트 컨트롤러
        
        // 노티피케이션 컨트롤러
        
        // 프로필 컨트롤러
    }
    
    // 네비게이션 컨트롤러 생성
    // ---> 탭바 아이템의 선택된 이미지를 기준으로 루트뷰 컨트롤러를 변경하여 뷰를 표시
    func configureNavigationCotroller(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // 네비게이션 컨트롤러 설정
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        //return nav Controller
        return navController
    }
}
