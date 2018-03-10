//
//  FeedVC.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    // Variables
    var feedMessage = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    // 獲取message並更新tableView Data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getAllFeedMessage { (returnMessage) in
            self.feedMessage = returnMessage.reversed()
            self.tableView.reloadData()
        }
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
        let image = UIImage(named: "defaultProfileImage")
        let message = feedMessage[indexPath.row]
        
        DataService.instance.getUsername(forUID: message.senderId) { (returnUsername) in
            cell.configureCell(profileImage: image!, email: returnUsername, content: message.content)
        }
        return cell
    }
}

