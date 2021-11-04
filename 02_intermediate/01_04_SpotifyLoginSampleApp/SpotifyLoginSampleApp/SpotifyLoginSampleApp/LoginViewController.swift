//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Jeonggi Hong on 2021/11/04.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // board추가
        [emailLoginButton,googleLoginButton,appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증
        
    }
    
    @IBAction func appLoginButtonTapped(_ sender: UIButton) {
    }
    
    
}
