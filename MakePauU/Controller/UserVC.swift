//
//  UserVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/29.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var statCollection: UICollectionView!
    @IBOutlet weak var dataTable: UITableView!
    
    //UI
    @IBOutlet weak var nameAndAgeLbl: UILabel!
    @IBOutlet weak var fansLbl: UILabel!
    @IBOutlet weak var introLbl: UILabel!
    

    @IBOutlet weak var imageCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTableHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var userInfo = UserInfo()
    
    var titleArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self.view)
        
        FirebaseService.shared().getUserInfo { (userInfo) in
            self.userInfo = userInfo
            
            self.statCollection.delegate = self
            self.statCollection.dataSource = self
            
            self.imageCollection.delegate = self
            self.imageCollection.dataSource = self
            
            self.introLbl.text = "\(userInfo.living!), \(userInfo.sex!), \(userInfo.school!)"
            self.nameAndAgeLbl.text = "\(userInfo.name!)"
            
            self.dataTable.reloadData()
            self.dataTable.tableFooterView = UIView()
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
        }
    } 
    
    override func viewDidAppear(_ animated: Bool) {
        self.dataTable.delegate = self
        self.dataTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustConstraint()
        
        self.dataTable.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        self.adjustConstraint()
        
        self.dataTable.estimatedRowHeight = 60.0
        self.dataTable.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func adjustConstraint(){
        imageCollectionHeight.constant = self.view.frame.width
        
        self.dataTableHeight?.constant = self.dataTable.contentSize.height + 150
        self.contentViewHeight.constant = self.view.frame.width + 290 + dataTableHeight.constant
    }
    
    @IBAction func editBtnpressed(_ sender: Any) {
        performSegue(withIdentifier: "toEditUserVC", sender: userInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditUserVC"{
            if let destination = segue.destination as? EditUserVC {
                if let dataobj = sender as? UserInfo {
                    destination.userInfo = dataobj
                }
            }
        }
    }
    
    @IBAction func unwindFromEditVC(_ sender: UIStoryboardSegue){
        
        FirebaseService.shared().getUserInfo { (userInfo) in
            self.userInfo = userInfo

            self.introLbl.text = "\(userInfo.living!), \(userInfo.sex!), \(userInfo.school!)"

            self.dataTable.reloadData()

            self.imageCollection.reloadData()
        }
    }
}

extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == imageCollection{
            return 1
        } else if collectionView == statCollection{
            return 3
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == imageCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as! UserImageCell
            cell.thumbImageView.image = userInfo.profileImage!
            
            return cell
            
        } else if collectionView == statCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as! StatCell
            
            let titleArray = ["總跑步次數", "總公里數", "平均時間"]
            
            
            let figureArray = ["\(userInfo.total_count!)", "\(userInfo.total_distance!)", "\(userInfo.total_time!)"]
            
            cell.titleLbl.text = titleArray[indexPath.row]
            cell.figureLbl.text = figureArray[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == imageCollection {
            return CGSize(width: collectionView.frame.size.width, height: self.view.frame.size.width)
        } else if collectionView == statCollection {
            return CGSize(width: (collectionView.frame.size.width - (collectionView.frame.size.width - 240)) / 3, height: collectionView.frame.size.height)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == statCollection{
            return (collectionView.frame.size.width - 260) / 2
        }
        return 0
    }
}

extension UserVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataCell{
            
            let titleArray = ["生日：", "感情取向：", "興趣愛好：", "最近的困擾：", "想嘗試的事："]
            let figureArray = [userInfo.birth!, userInfo.sex_prefer!, userInfo.interest!, userInfo.problem!, userInfo.tries!] 
            
            cell.titleLbl.text = titleArray[indexPath.row]
            cell.contentLbl.text = figureArray[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


