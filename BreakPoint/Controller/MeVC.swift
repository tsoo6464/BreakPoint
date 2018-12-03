//
//  MeVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/8.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class MeVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Variable
    let realm = try! Realm()
    var user = User()
    let size = CGSize(width: 100, height: 100)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
        AuthService.instance.getMyUserInfo(completion: { (user) in
            self.profileImage.image = UIImage(data: user.profileImage!)
        })
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let users = realm.objects(User.self).filter("uid CONTAINS %@", uid)
        if !users.isEmpty {
            user = users[0]
        }
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
    
    @IBAction func profileImageBtnWasPressed(_ sender: Any) {
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "Upload pictures", message: "Please select the image to upload.", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "Choose from Library", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "Take Photo", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
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

extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let cgsize = CGSize(width: 100, height: 100)
            let newImage = pickedImage.imageWithNewSize(size: cgsize)
            selectedImageFromPicker = newImage
        }
        print("____________________________")
        // 當判斷有 selectedImage 時，會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            DataService.instance.uploadUserImage(uid: (Auth.auth().currentUser?.uid)!, image: selectedImage, completion: { (success) in
                if success {
                    self.profileImage.image = selectedImage
                    self.profileImage.clipsToBounds = true
                    do {
                        let data = selectedImage.pngData()
                        try self.realm.write {
                            self.user.profileImage = data
                            
                        }
                    } catch {
                        print("Error updating user, \(error)")
                    }
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
