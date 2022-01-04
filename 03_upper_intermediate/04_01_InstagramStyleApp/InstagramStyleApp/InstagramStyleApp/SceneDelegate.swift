//
//  SceneDelegate.swift
//  InstagramStyleApp
//
//  Created by Jeonggi Hong on 2022/01/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = TabBarController()
        window?.tintColor = .label // light 모드에서는 black, dark 모드에서는 white
        window?.makeKeyAndVisible()
    }


}

