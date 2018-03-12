//
//  Group.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation

class Group {
    private(set) public var groupTitle: String
    private(set) public var groupDescription: String
    private(set) public var key: String
    private(set) public var memberCount: Int
    private(set) public var members: [String]
    
    init(title: String, description: String, key: String, memberCount: Int, members: [String]) {
        self.groupTitle = title
        self.groupDescription = description
        self.key = key
        self.memberCount = memberCount
        self.members = members
    }
}
