//
//  NewMessageController.swift
//  chatchatchat
//
//  Created by Hsieh Tony on 2018/6/6.
//  Copyright © 2018 Hsieh Tony. All rights reserved.
//

import UIKit
import Firebase

// 好友列表
class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    //有了
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (DataSnapshot) in
            
            //得到資料庫的uid,姓名email資料
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = DataSnapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //先用hack，我們需要dequeue our cells for memory efficiency
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        //放人的照片
        cell.imageView?.image = UIImage(named: "man")
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //間距
        return 72
    }
    
    //呈現聊天畫面
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user:user)
        }
    }
}












