//
//  MailVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/27.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class MailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var email: MailboxItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension MailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailCell", for: indexPath) as! MailCell
        
        var titleArray = ["標題", "時間", "寄件人", "信件內容"]
        var contentArray = [email.title, email.date, email.sender, email.content]
        
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.contentLbl.text = contentArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
