//
//  AuthVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AuthVC: UIViewController {
    
    // Outlets

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
        
    }
    // Facebook登入
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            // 取得FB帳號token
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            AuthService.instance.loginUserForFB(withCredential: credential, loginComplete: { (success, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription as Any)
                } else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            })
        }
    }
}
