//
//  GroupFeedVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class GroupFeedVC: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTxt: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    // Variables
    let realm = try! Realm()
    var group: Group?
    var groupMessage = [Message]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtnView.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let group = group else { return }
        groupTitle.text = group.groupTitle
        DataService.instance.getGroupUsername(forGroup: group) { (returnEmailArray) in
            self.membersLbl.text = returnEmailArray.joined(separator: ", ")
        }
        // 更新用戶圖片
        DataService.instance.REF_USERS.observe(.value) { (snapshot) in
            DataService.instance.updateUserImage(completion: { (success) in
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let group = group else { return }
        DataService.instance.REF_GROUPS.child(group.key).child("messages").observe(.value) { (dataSnapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: group) { (returnGroupMessage) in
                self.groupMessage = returnGroupMessage
                self.tableView.reloadData()
                
                if self.groupMessage.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessage.count - 1, section: 0), at: .none, animated: true)
                }
            }
        }
    }
    
    // Action
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        guard let msg = messageTxt.text, messageTxt.text != "" else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let group = group else { return }
        messageTxt.isEnabled = false
        sendBtn.isEnabled = false
        DataService.instance.uploadPost(withMessage: msg, forUID: uid, withGroupKey: group.key) { (complete) in
            if complete {
                self.messageTxt.text = ""
                self.messageTxt.isEnabled = true
                self.sendBtn.isEnabled = true
            }
        }
    }
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedCell else { return GroupFeedCell()}
        
        let image = UIImage(named: "defaultProfileImage")
        let message = groupMessage[indexPath.row]
        let userArray = realm.objects(User.self).filter("uid CONTAINS %@", message.senderId)
        
        DataService.instance.getUsername(forUID: message.senderId) { (returnEmail) in
            if !userArray.isEmpty {
                let user = userArray[0]
                cell.configureCell(image: UIImage(data: user.profileImage!)!, email: returnEmail, content: message.content)
            } else {
                cell.configureCell(image: image!, email: returnEmail, content: message.content)
            }
        }
        return cell
    }
}
