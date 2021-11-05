//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Jeonggi Hong on 2021/11/04.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인화면에서 뒤로가는 것 막기
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
        // 소셜로그인일 경우 비밀번호 변경 숨기기
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        // 로그아웃
        let firebaseAuth = Auth.auth()
        
        // 에러 처리를 위한 throw 함수 이기때문에 do catch
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            // 에러발생
            print("ERROR: signout \(signOutError.localizedDescription)")
        }

    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        
        // 이메일로 비밀번호 변경보내기
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    
    
    }
}
