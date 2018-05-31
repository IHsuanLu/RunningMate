//
//  Setting.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/23.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class Setting: NSObject {

    var blackView = UIView()
    var contentView = UIView()
    var topView = UIView()
    
    let titleLabel = UILabel()
    let dismissBtn = UIButton()
    
    // create tableView
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = UIColor(netHex: 0xE9A11A)
        tb.isScrollEnabled = false
        
        tb.delegate = self
        tb.dataSource = self
        let nibName = UINib(nibName: "SettingCell", bundle: nil)
        tb.register(nibName, forCellReuseIdentifier: "SettingCell")
        
        return tb
    }()

    var firstPageVC = FirstPageVC()

    
    func showSetting(){
        
        // access the whole screen
        if let window = UIApplication.shared.keyWindow{
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            
            //tap to dismiss
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.frame = window.frame  // set constraint
            blackView.alpha = 0
            window.addSubview(blackView)
            
            contentView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            contentView.backgroundColor = UIColor(netHex: 0xFFFFFF)
            window.addSubview(contentView)
            
            topView.frame = CGRect(x: 0, y: 0, width: 0, height: 64)
            topView.backgroundColor = UIColor(netHex: 0xE9A11A)
            contentView.addSubview(topView)
            
            dismissBtn.frame = CGRect(x: 8, y: 30, width: 30, height: 30)
            dismissBtn.setImage(#imageLiteral(resourceName: "return_white"), for: .normal)
            dismissBtn.addTarget(self, action: #selector(returnBtnPressed), for: .touchUpInside)
            topView.addSubview(dismissBtn)
            
            titleLabel.frame = CGRect(x:  window.frame.width * 4 / 5 / 2 - 60, y: 30, width: 120, height: 25)
            titleLabel.text = "SETTING"
            titleLabel.textColor = UIColor(netHex: 0xFFFFFF)
            let normalFont = UIFont(name: "Helvetica neue", size: 17)
            titleLabel.font = UIFont(descriptor: (normalFont?.fontDescriptor.withSymbolicTraits(.traitBold)!)!, size: (normalFont?.pointSize)!)
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = UIColor.clear
            contentView.addSubview(titleLabel)
        
            tableView.frame = CGRect(x: 0, y: 72, width: 0, height: window.frame.height - 72)
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor(netHex: 0xffffff)
            contentView.addSubview(tableView)
            
            
            //從一般的animate改成"usingSpringWithDamping" (for more smoother)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //Note that blackView的alpha還是1, 即便backgroundcolor是0.5
                self.blackView.alpha = 1
                self.contentView.frame = CGRect(x: 0, y: 0, width: window.frame.width * 4 / 5, height: self.contentView.frame.height)
                self.topView.frame = CGRect(x: 0, y: 0, width: window.frame.width * 4 / 5, height: self.topView.frame.height)
                self.tableView.frame = CGRect(x: 0, y: 72, width: window.frame.width * 4 / 5, height: self.contentView.frame.height - 72)
                
                self.titleLabel.isHidden = false
                self.dismissBtn.isHidden = false

            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.contentView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
                self.topView.frame = CGRect(x: 0, y: 0, width: 0, height: self.topView.frame.height)
                self.tableView.frame = CGRect(x: 0, y: 72, width: 0, height: self.contentView.frame.height - 72)
            }

            self.titleLabel.isHidden = true
            self.dismissBtn.isHidden = true
        }
    }
    
    @objc func returnBtnPressed(){
       
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.contentView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
                self.topView.frame = CGRect(x: 0, y: 0, width: 0, height: self.topView.frame.height)
                self.tableView.frame = CGRect(x: 0, y: 72, width: 0, height: self.contentView.frame.height - 72)
            }
            
            self.titleLabel.isHidden = true
            self.dismissBtn.isHidden = true
        }
    }
    
    override init() {
        super.init()
        
        
    }
}

extension Setting: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        let imageArray = [#imageLiteral(resourceName: "password1"), #imageLiteral(resourceName: "wallet1"), #imageLiteral(resourceName: "question"), #imageLiteral(resourceName: "instruction"), #imageLiteral(resourceName: "log_out")]
        let textArray = ["更改密碼", "我的錢包", "常見問題", "關於我們", "登出"]
        
        cell.titleLbl.text = textArray[indexPath.row]
        cell.iconImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            ApiService.sharedInstance.logout {
                self.firstPageVC.performSegue(withIdentifier: "logout", sender: nil)
                print("Done!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}





