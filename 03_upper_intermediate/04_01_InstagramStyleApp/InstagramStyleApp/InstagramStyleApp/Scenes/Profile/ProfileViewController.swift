//
//  ProfileViewController.swift
//  InstagramStyleApp
//
//  Created by Jeonggi Hong on 2022/01/04.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
    
}

private extension ProfileViewController {
    func setupNavigationItems() {
        navigationItem.title = "UserName"
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
