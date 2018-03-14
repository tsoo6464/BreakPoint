//
//  GroupFeedCell.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(image: UIImage, email: String, content: String) {
        self.profileImage.image = image
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
}
