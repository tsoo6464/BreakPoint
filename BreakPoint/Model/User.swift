//
//  User.swift
//  BreakPoint
//
//  Created by Nan on 2018/10/18.
//  Copyright © 2018 nan. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var imageURLString: String = "defaultProfileImage"
    @objc dynamic var profileImage: Data?
}
