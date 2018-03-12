//
//  UserCell.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/11.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    func configureCell(image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.emailLbl.text = email
        self.checkImage.isHidden = isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if self.checkImage.isHidden {
                self.checkImage.isHidden = false
            } else {
                self.checkImage.isHidden = true
            }
        }
    }

}
