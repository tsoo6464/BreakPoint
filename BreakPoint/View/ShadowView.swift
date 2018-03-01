//
//  ShadowView.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func awakeFromNib() {
        // 圖層陰影的不透明度
        self.layer.shadowOpacity = 0.85
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        super.awakeFromNib()
    }
}
