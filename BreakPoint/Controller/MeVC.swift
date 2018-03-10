//
//  MeVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/8.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
    }
    // Action
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        // 用AlertViewController做登出確認
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Yes", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                debugPrint(error.localizedDescription as Any)
            }
        }
        let action = UIAlertAction(title: "No", style: .cancel, handler: nil)
        logoutPopup.addAction(action)
        logoutPopup.addAction(logoutAction)
        
        present(logoutPopup, animated: true, completion: nil)
    }
    
}

extension MeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
