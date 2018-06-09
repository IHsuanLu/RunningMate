//
//  MessagesVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/9.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UITableViewController {
    
    let cellId = "cellId"
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAndSetupNavBarTitle()
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    var messages = [Message]()
    //將訊息群組化
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        
        let ref = Database.database().reference().child("user-messages").child(MemberId.sharedInstance.member_id)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            print(snapshot.key)
            
            Database.database().reference().child("user-messages").child(MemberId.sharedInstance.member_id).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observe(.value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                message.setValuesForKeys(dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    
                }
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        //讓它停留一陣子
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        //按照時間排列
        self.messages.sort(by: { (messages1, messages2) -> Bool in
            
            return (messages1.timestamp?.intValue)! > (messages2.timestamp?.intValue)!
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //列出訊息
    override func tableView(_ mytableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    override func tableView(_ mytableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //間距
        return 72
    }
    
    //按聊天記錄繼續聊天
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("members").child(chatPartnerId)
        
        ref.observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: AnyObject] else { return }
            
            let name = value["name"] as! String
            
            let user = UserClass(id: chatPartnerId, name: name)
            
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
    
    func fetchUserAndSetupNavBarTitle() {
        Database.database().reference().child("members").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
            //資料庫的email, name = snapshot
            
            let id = snapshot.key
        
            if let value = snapshot.value as? [String: AnyObject] {
                
                let name = value["name"] as! String
                self.navigationItem.title = "CHAT"
                
                let user = UserClass(id: id, name: name)
                
                self.setupNavBarWithUser(user: user)
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: UserClass) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
    }
    
    func showChatControllerForUser(user: UserClass) {
        let chatLogController = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
