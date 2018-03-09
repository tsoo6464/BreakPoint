//
//  Message.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/9.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation

class Message {
    private(set) public var content: String
    private(set) public var senderId: String
    
    init(content: String, senderId: String) {
        self.content = content
        self.senderId = senderId
    }
}
