//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Jeonggi Hong on 2021/11/04.
//

import UIKit

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        
        // text를 가져오기 위함
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 처음 동작시 커서가 자동으로 위치하도록
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation Bar 보이기
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
    
    
}

extension EnterEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    
}
