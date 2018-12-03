//
//  CreatePostVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/8.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class CreatePostVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    // Variables
    let realm = try! Realm()
    var profileImageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        sendBtn.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let users = realm.objects(User.self).filter("uid CONTAINS %@", uid)
        if !users.isEmpty {
            let user = users[0]
            profileImageData = user.profileImage!
            profileImage.image = UIImage(data: profileImageData)!
        } else {
            profileImage.image = UIImage(named: "defaultProfileImage")
        }
    }
    // Action
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        guard let message = textView.text, textView.text != "", textView.text != "Say something here..." else { return }
        sendBtn.isEnabled = false
        DataService.instance.uploadPost(withMessage: message, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (success) in
            if success {
                self.sendBtn.isEnabled = true
                self.dismiss(animated: true, completion: nil)
            } else {
                self.sendBtn.isEnabled = true
                print("There was an error!")
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
