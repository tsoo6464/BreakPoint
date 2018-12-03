//
//  FeedVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import RealmSwift

class FeedVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    // Variables
    var feedMessage = [Message]()
    var userArray: Results<User>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    // 獲取message並更新tableView Data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getAllFeedMessage { (returnMessage) in
            self.load()
            self.feedMessage = returnMessage.reversed()
            self.tableView.reloadData()
        }
        DataService.instance.REF_USERS.observe(.value) { (snapShot) in
            DataService.instance.updateUserImage(completion: { (success) in
            })
        }
    }
    
    func load() {
        userArray = realm.objects(User.self)
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return FeedCell() }
        let message = feedMessage[indexPath.row]
        
        load()
        userArray = userArray?.filter("uid CONTAINS %@", message.senderId)
        // 本地端無資料 要需下載
        if (userArray?.isEmpty)! {
            DataService.instance.getFeedProfileImage(forUID: message.senderId) { (returnURLString) in
                DataService.instance.getUsername(forUID: message.senderId, completion: { (returnUsername) in
                    if returnURLString != "defaultProfileImage" {
                        let url = URL(string: returnURLString)!
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                print("Failed")
                            } else {
                                DispatchQueue.main.async(execute: {
                                    do {
                                        let newUser = User()
                                        newUser.uid = message.senderId
                                        newUser.email = returnUsername
                                        newUser.imageURLString = returnURLString
                                        newUser.profileImage = data
                                        try self.realm.write {
                                            self.realm.add(newUser)
                                        }
                                    } catch {
                                        print("Error saving user, \(error)")
                                    }
                                })
                            }
                        })
                        task.resume()
                    } else {
                        // 如果載下來的URLString等於預設圖片
                        cell.configureCell(profileImage: UIImage(named: returnURLString)!, email: returnUsername, content: message.content)
                    }
                })
            }
        } else {
            // 本地端有資料直接使用
            if let user = userArray?[0] {
                cell.configureCell(profileImage: UIImage(data: user.profileImage!)!, email: user.email, content: message.content)
            }
        }
        
//        DataService.instance.getFeedProfileImage(forUID: message.senderId) { (returnUrlString) in
//            DataService.instance.getUsername(forUID: message.senderId, completion: { (returnUsername) in
//                if returnUrlString != "defaultProfileImage" {
//
//                    let url = URL(string: returnUrlString)!
//                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                        if error != nil {
//                            print("Failed")
//                        } else {
//                            DispatchQueue.main.async(execute: {
//                                self.load()
//                                self.userArray = self.userArray?.filter("uid CONTAINS %@", message.senderId)
//                                if (self.userArray?.isEmpty)! {
//                                    // 本地端沒有資料 需要下載並儲存本地端
//                                    guard let imageData = data else { return }
//                                    if let image = UIImage(data: imageData) {
//                                        cell.configureCell(profileImage: image, email: returnUsername, content: message.content)
//                                        do {
//                                            let newUser = User()
//                                            newUser.email = returnUsername
//                                            newUser.uid = message.senderId
//                                            newUser.profileImage = imageData
//                                            newUser.imageURLString = returnUrlString
//                                            try self.realm.write {
//                                                self.realm.add(newUser)
//                                            }
//                                        } catch {
//                                            print("Error saving user, \(error)")
//                                        }
//                                    }
//                                } else {
//                                    // 本地端有資料 要比對和下載的資料有無不同
//                                    // 不同就更新本地端 相同直接使用
//                                    if let user = self.userArray?[0] {
//                                        //相同
//                                        if (user.profileImage?.elementsEqual(data!))! {
//                                            cell.configureCell(profileImage: UIImage(data: data!)!, email: returnUsername, content: message.content)
//                                        } else {
//                                            // 不同需更新本地資料
//                                            do {
//                                                try self.realm.write {
//                                                    user.profileImage = data!
//                                                }
//                                                cell.configureCell(profileImage: UIImage(data: data!)!, email: returnUsername, content: message.content)
//                                            } catch {
//                                                print("Error updating user, \(error)")
//                                            }
//                                        }
//                                    }
//
//                                }
//                            })
//                        }
//                    })
//                    task.resume()
//                } else {
//                    // 如果載下來的URLString等於預設圖片
//                    cell.configureCell(profileImage: UIImage(named: returnUrlString)!, email: returnUsername, content: message.content)
//                }
//            })
//        }
        return cell
    }
}

