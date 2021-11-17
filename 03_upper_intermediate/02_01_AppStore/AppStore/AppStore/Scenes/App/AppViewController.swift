//
//  AppViewController.swift
//  AppStore
//
//  Created by Jeonggi Hong on 2021/11/17.
//

import SnapKit
import UIKit

final class AppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
    }
}

private extension AppViewController {
    func setupNavigationController() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
