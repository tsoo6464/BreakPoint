//
//  GroupCell.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescriptionLbl: UILabel!
    @IBOutlet weak var memberCountLbl: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLbl.text = title
        self.groupDescriptionLbl.text = description
        self.memberCountLbl.text = "\(memberCount) members."
    }
    
}
