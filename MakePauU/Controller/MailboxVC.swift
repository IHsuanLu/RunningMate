//
//  MailboxVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/27.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

//帶資料
import UIKit

class MailboxVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wallpaperImageView: UIImageView!
    @IBOutlet weak var hideADBtn: UIButton!
    
    @IBOutlet weak var wallpaperHeight: NSLayoutConstraint!
    
    var ifADExpanded = true
    var emails: [MailboxItem]!
    var mailStatuschange: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FirebaseService.sharedInstance.setInbox { (emails) in
            self.emails = emails
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func hideADBtnPressed(_ sender: Any) {
        
        ifADExpanded = !ifADExpanded
        
        if !ifADExpanded {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.wallpaperHeight.constant = 0
                self.hideADBtn.setTitle("Show AD", for: .normal)
                self.hideADBtn.frame = CGRect(x: 0, y: 64, width: 85, height: 24)
                self.wallpaperImageView.frame = CGRect(x: 0, y: 64, width: 0, height: 0)
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.wallpaperHeight.constant = self.view.frame.height * 0.30
                self.hideADBtn.setTitle("Hide AD", for: .normal)
                self.hideADBtn.frame = CGRect(x: 0, y: self.view.frame.height * 0.30, width: 85, height: 24)
                self.wallpaperImageView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height * 0.30)
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @IBAction func backFromMail(segue: UIStoryboardSegue) {
        
        
        
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMailVC" {
            if let destination = segue.destination as? MailVC{
                if let email = sender as? MailboxItem {
                    destination.email = email
                }
            }
        }
    }
}

extension MailboxVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailboxCell", for: indexPath) as! MailboxCell
        
            switch emails[indexPath.row].ifSeen {
            case 1:
                cell.statusImageView.image = UIImage(named: "seen")
            case 0:
                cell.statusImageView.image = UIImage(named: "unseen")
            default:
                cell.statusImageView.image = UIImage(named: "unseen")
            }
        
            cell.titleLbl.text = emails[indexPath.row].title
            cell.dateLbl.text = emails[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(emails.count)
        
        if emails[indexPath.row].ifSeen == 0 {
            emails[indexPath.row].ifSeen = 1
            mailStatuschange.append(indexPath.row + 1)
        }

        performSegue(withIdentifier: "toMailVC", sender: emails[indexPath.row])
    }
}
