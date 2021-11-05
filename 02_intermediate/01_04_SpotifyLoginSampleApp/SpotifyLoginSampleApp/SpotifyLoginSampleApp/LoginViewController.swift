//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Jeonggi Hong on 2021/11/04.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
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
    
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        // Firebase 인증정보를 가져온다
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let signInconfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: signInconfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let authentication = user?.authentication else { return }
            let crdential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            // access token 부여 받음
            
            // Firebase 인증정보 등록
            Auth.auth().signIn(with: crdential) {_, _ in
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨준다
                self.showMainViewController()
            }
        }
        
    }
    
    @IBAction func appLoginButtonTapped(_ sender: UIButton) {
    }
    
    private func showMainViewController() {
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
           mainViewController.modalPresentationStyle = .fullScreen
           
           UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
       }
    
}
