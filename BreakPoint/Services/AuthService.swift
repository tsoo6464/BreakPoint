//
//  AuthService.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/2.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation
import Firebase


class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (User, Error) in
            guard let user = User else {
                userCreationComplete(false, Error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(wihtEmail email: String, andPassword password: String, loginComplete: @escaping CompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (User, Error) in
            if Error != nil {
                loginComplete(false, Error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
