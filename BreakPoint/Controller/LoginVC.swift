//
//  LoginVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTxt: InsetTextField!
    @IBOutlet weak var passwordTxt: InsetTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
    }
    // 登入帳號 (先嘗試登入 若登入失敗就註冊帳戶並登入)
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        guard let email = emailTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        AuthService.instance.loginUser(wihtEmail: email, andPassword: password) { (loginSuccess, loginError) in
            if loginError == nil {
                self.dismiss(animated: true, completion: nil)
                return
            } else {
                debugPrint(loginError?.localizedDescription as Any)
            }
        }
        
        AuthService.instance.registerUser(withEmail: email, andPassword: password) { (success, registerError) in
            if registerError == nil {
                AuthService.instance.loginUser(wihtEmail: email, andPassword: password, loginComplete: { (success, nil) in
                    self.dismiss(animated: true, completion: nil)
                    print("Successfully registered user")
                })
            } else {
                debugPrint(registerError?.localizedDescription as Any)
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate { }
