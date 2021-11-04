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
}
