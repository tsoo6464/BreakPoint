//
//  AuthService.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/2.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (User, Error) in
            guard let user = User else {
                userCreationComplete(false, Error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email!, "profileImage": "defaultProfileImage"]
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
    
    func loginUserForFB(withCredential credential: AuthCredential, loginComplete: @escaping CompletionHandler) {
        Auth.auth().signIn(with: credential) { (User, Error) in
            if Error != nil {
                loginComplete(false, Error)
                return
            }
            guard let user = User else { return }
            let userData = ["provider": user.providerID, "email": user.email!, "profileImage": "defaultProfileImage"]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            loginComplete(true, nil)
        }
    }
    
    func getMyUserInfo(completion: @escaping (_ userInfo: User) -> ()) {
        let realm = try! Realm()
        let myUserInfo = User()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let email = currentUser.email else { return }
        let uid = currentUser.uid
        
        let users: Results<User>? = realm.objects(User.self).filter("uid CONTAINS %@", uid)
        
        if (users?.isEmpty)! {
            myUserInfo.profileImage = UIImage(named: "defaultProfileImage")?.pngData()
        } else {
            myUserInfo.profileImage = users?[0].profileImage
        }
        
        myUserInfo.email = email
        myUserInfo.uid = uid
        
        completion(myUserInfo)
    }
}
