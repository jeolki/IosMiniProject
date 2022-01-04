//
//  TabBarController.swift
//  InstagramStyleApp
//
//  Created by Jeonggi Hong on 2022/01/04.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TabBar 설정
        let feedViewController = UINavigationController(rootViewController: FeedViewController()) // 임의
        feedViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())// 임의
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // 2가지 등록
        viewControllers = [feedViewController, profileViewController]
    }
}
