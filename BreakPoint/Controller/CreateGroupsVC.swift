//
//  CreateGroupsVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/11.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {
    // Outlets
    @IBOutlet weak var titleTxt: InsetTextField!
    @IBOutlet weak var descriptionTxt: InsetTextField!
    @IBOutlet weak var emailSearchTxt: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    // Variables
    var emailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTxt.delegate = self
        emailSearchTxt.addTarget(self, action: #selector(CreateGroupsVC.emailSearchTxtChange), for: .editingChanged)
    }
    // 搜尋textField內輸入條件的email
    @objc func emailSearchTxtChange() {
        guard let searchQuery = emailSearchTxt.text, emailSearchTxt.text != "" else {
            // 若搜尋內容為"" 則將emailArray清空並且重載入tableView
            emailArray = []
            tableView.reloadData()
            return
        }
        // 獲取搜尋條件相符的email
        DataService.instance.getEmail(forSearchQuery: searchQuery) { (returnEmailArray) in
            self.emailArray = returnEmailArray
            self.tableView.reloadData()
        }
    }
    
    // Action
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }
    
}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UserCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        let userEmail = emailArray[indexPath.row]
        cell.configureCell(image: profileImage!, email: userEmail, isSelected: true)
        return cell
    }
}

extension CreateGroupsVC: UITextFieldDelegate { }
