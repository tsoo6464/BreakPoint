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
}
