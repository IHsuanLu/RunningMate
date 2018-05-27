//
//  FirstPageVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/11.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FirstPageVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var pic = UIImage()
    
    lazy var setting: Setting = {
        let setting = Setting()
        setting.firstPageVC = self
        
        return setting
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self.view)
        
        FirebaseService.sharedInstance.setFirstPage(completion: { (name, count, distance, average_time, pic)  in
            
            self.nameLbl.text = name
            self.countLbl.text = "\(count)"
            self.distanceLbl.text = "\(distance)"
            self.timeLbl.text = "\(Int(Double(average_time / 60)))'\(Int(round(Double(average_time.truncatingRemainder(dividingBy: 60)))))''"
            self.profileImageView.image = pic
            
            self.pic = pic
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
        })
    }
    
    @IBAction func profileBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toProfileImageVC", sender: nil)
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        setting.showSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toProfileImageVC"{
            if let destination = segue.destination as? ProfileImageVC{
                destination.image = self.pic
            }
        }
    }
    
    @IBAction func backFromMailBox(segue: UIStoryboardSegue) {
        
        guard let mailboxobj = segue.source as? MailboxVC else { return }
        
        print(mailboxobj.mailStatuschange)
        
        for i in mailboxobj.mailStatuschange {
            FirebaseService.sharedInstance.updateInbox(number: i)
        }
        
        self.tabBarController?.selectedIndex = 0
        print("We are back")
    }
}
