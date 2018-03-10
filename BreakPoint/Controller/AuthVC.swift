//
//  AuthVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase

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
    
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
        
    }
}
