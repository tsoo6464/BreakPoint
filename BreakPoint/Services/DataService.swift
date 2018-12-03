//
//  DataService.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import RealmSwift
// 取得database的根目錄 即database的URL根
let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    // 建立子目錄(在Firebase裡若child不存在 會建立新的 防止閃退)
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_GROUPS = DB_BASE.child("groups")
    public private(set) var REF_FEED = DB_BASE.child("feed")
    
    private let realm = try! Realm()
    // 建立以uid為唯一識別的UserDB
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    // 用id取得email
    func getUsername(forUID uid: String, completion: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userInfoSnapshot) in
            guard let users = userInfoSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in users {
                if user.key == uid {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    completion(email)
                }
            }
        }
    }
    // 取得group內member的email
    func getGroupUsername(forGroup group: Group, completion: @escaping (_ groupUsername: [String]) -> ()) {
        var groupUsernameArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userInfoSnapshot) in
            guard let users = userInfoSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in users {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    groupUsernameArray.append(email)
                }
            }
            completion(groupUsernameArray)
        }
    }
    //上傳訊息功能
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendCompletion: @escaping (_ success: Bool) -> ()) {
        guard let groupKey = groupKey else {
            // 產生一組Id 然後記錄下發送訊息人ID和內容
            // (無groupKey)
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendCompletion(true)
            return
        }
        // (has groups key)send to groups ref
        // 找到對應的group 並建立message
        REF_GROUPS.child(groupKey).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
        sendCompletion(true)
    }
    // 獲得所有的feedMessage
    func getAllFeedMessage(completion: @escaping (_ message: [Message]) -> ()) {
        var messageArray = [Message]()
        // 獲得feed的databaseRef的，dataSnapshot在取得所有的訊息
        REF_FEED.observe(.value) { (feedMessageSnapshot) in
            guard let feedMsgSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            //解開message
            for message in feedMsgSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feedMessage = Message(content: content, senderId: senderId)
                messageArray.append(feedMessage)
            }
            
            completion(messageArray)
        }
    }
    // 獲取群組message功能
    func getAllMessagesFor(desiredGroup: Group, completion: @escaping (_ messageArray: [Message]) -> ()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observe(.value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in groupMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            completion(groupMessageArray)
        }
    }
    // 獲得與搜尋相關的email
    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            completion(emailArray)
        }
    }
    // 用email獲取uid(group使用)
    func getUID(forUsernames username: [String], completion: @escaping (_ uidArray: [String]) -> ()) {
        var idArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email) {
                    idArray.append(user.key)
                }
            }
            completion(idArray)
        }
    }
    // 創建group
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], completion: @escaping (_ createComplete: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        completion(true)
    }
    //
    func getAllGroup(completion: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot], let myUID = Auth.auth().currentUser?.uid else { return }
            for group in groupSnapshot {
                // 取得這個group的members
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                // members裡是否有自己 有的話就加入到group裡
                if memberArray.contains(myUID) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let myGroup = Group(title: title, description: description, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(myGroup)
                }
            }
            completion(groupsArray)
        }
    }
    // 上傳用戶照片
    func uploadUserImage(uid: String, image: UIImage, completion: @escaping (_ success: Bool) -> ()) {
        let storageRef = Storage.storage().reference().child("UserProfileImage").child("\(uid).png")
        let user = realm.objects(User.self).filter("uid CONTAINS %@", uid)
        
        if let uploadData = image.pngData() {
            // 這行就是 FirebaseStorage 關鍵的存取方法。
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                    completion(false)
                }
                
                // 連結取得方式：data?.downloadURL()?.absoluteString。
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    do {
                        try self.realm.write {
                            user[0].imageURLString = uploadImageUrl
                        }
                        self.REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["profileImage": uploadImageUrl])
                    } catch {
                        print("Error updating userImageURLString, \(error)")
                    }
                }
                completion(true)
            })
        }
    }
    
    func getFeedProfileImage(forUID uid: String, completion: @escaping (_ urlString: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userDataSnapShot) in
            guard let userDataSnapShot = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userDataSnapShot {
                if user.key == uid {
                    let urlString = user.childSnapshot(forPath: "profileImage").value as! String
                    completion(urlString)
                }
            }
        }
    }
    // 更新用戶圖片
    func updateUserImage(completion: @escaping (_ success: Bool) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (snapShot) in
            guard let users = snapShot.children.allObjects as? [DataSnapshot] else {
                completion(false)
                return}
            let userArray = self.realm.objects(User.self)
            
            for user in users {
                let returnURLString = user.childSnapshot(forPath: "profileImage").value as! String
                if returnURLString != "defaultProfileImage" {
                    for realmUser in userArray {
                        if realmUser.uid == user.key {
                            if realmUser.imageURLString != returnURLString {
                                let url = URL(string: returnURLString)!
                                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                                    if error == nil {
                                        DispatchQueue.main.async(execute: {
                                            do {
                                                try self.realm.write {
                                                    realmUser.profileImage = data
                                                    realmUser.imageURLString = user.childSnapshot(forPath: "profileImage").value as! String
                                                }
                                                print("SUCCESS!!!!!")
                                            } catch {
                                                print("Error updating user, \(error)")
                                            }
                                        })
                                    }
                                })
                                task.resume()
                            }
                        }
                    }
                }
            }
            completion(true)
        }
    }
}

