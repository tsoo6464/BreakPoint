//
//  CircleImage.swift
//  BreakPoint
//
//  Created by Nan on 2018/10/22.
//  Copyright © 2018 nan. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    func setUpView() {
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.clipsToBounds = true
    }
}
