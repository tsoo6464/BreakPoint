//
//  DataService.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation
import Firebase
// 取得database的根目錄 即database的URL根
let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    // 建立子目錄(在Firebase裡若child不存在 會建立新的 防止閃退)
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_GROUPS = DB_BASE.child("groups")
    public private(set) var REF_FEED = DB_BASE.child("feed")
    // 建立以uid為唯一識別的UserDB
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendCompletion: @escaping (_ success: Bool) -> ()) {
        if groupKey != nil {
            // send to groups ref
        } else {
            // 產生一組Id 然後記錄下發送訊息人ID和內容
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendCompletion(true)
        }
    }
    // 獲得所有的feedMessage
    func getAllFeedMessage(completion: @escaping (_ message: [Message]) -> ()) {
        var messageArray = [Message]()
        // 獲得feed的databaseRef的，dataSnapshot在取得所有的訊息
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMsgSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMsgSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feedMessage = Message(content: content, senderId: senderId)
                messageArray.append(feedMessage)
            }
            
            completion(messageArray)
        }
    }
}
