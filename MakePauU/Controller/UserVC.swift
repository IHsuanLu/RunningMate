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
    @IBOutlet weak var pageControl: UIPageControl!
    

    @IBOutlet weak var imageCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTableHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pagecontrolToTop: NSLayoutConstraint!
    
    
    var testArray: [UserImageItem]!
    var testArray2: [StatItem]!
    var testArray3: [DataItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testArray = [
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1"))
        ]
        
        testArray2 = [
            StatItem(figure: "8"),
            StatItem(figure: "19.31"),
            StatItem(figure: "11")
        ]
        
        testArray3 = [
            DataItem(title: "生日：", content: "1996 / 12 / 20"),
            DataItem(title: "感情狀況：", content: "有三個小狼狗跟一個乾爹"),
            DataItem(title: "興趣愛好：", content: "喜歡看各種類型的電影和徹夜不眠追劇\n國中時喜歡看天真浪漫不切實際的愛情片\n幻想男主角都是我的老公/n年幼無知憧憬愛情\n殊不知 那只是電影 只是 電影老公們都是有收錢的\n最終娶的都不是我 :(\n傷了心\n高中時喜歡古裝武打片\n看古人們輕功飛簷走壁\n以為自己也可以傷了身"),
            DataItem(title: "最近的困擾：", content: "嘴巴上每天都說想減肥\n可是看到美食又忘記自己立下的毒誓\n希望有人可以陪我一起運動"),
            DataItem(title: "想嘗試的事：", content: "想找一項活動\n可以療癒我的身心靈")
        ]
        
        adjustConstraint()
        
        pageControl.numberOfPages = testArray.count
        
        dataTable.estimatedRowHeight = 60.0
        dataTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.dataTableHeight?.constant = self.dataTable.contentSize.height
        
        self.contentViewHeight.constant = self.view.frame.width + 290 + dataTableHeight.constant
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width / 1.05)
    }
    
    func adjustConstraint(){
        imageCollectionHeight.constant = self.view.frame.width
        pagecontrolToTop.constant = self.imageCollection.frame.size.width - 55
    }
    
    @IBAction func editBtnpressed(_ sender: Any) {
        performSegue(withIdentifier: "toEditUserVC", sender: testArray3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditUserVC"{
            if let destination = segue.destination as? EditUserVC {
                if let dataobj = sender as? [DataItem] {
                    destination.datas = dataobj
                }
            }
        }
    }
}

extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == imageCollection{
            return testArray.count
        } else if collectionView == statCollection{
            return testArray2.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == imageCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as! UserImageCell
            cell.thumbImageView.image = testArray[indexPath.row].image
            
            return cell
            
        } else if collectionView == statCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as! StatCell
            
            let array = ["總跑步次數", "總公里數", "成就達成"]
            cell.titleLbl.text = array[indexPath.row]
            cell.figureLbl.text = testArray2[indexPath.row].figure
            
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
        return testArray3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataCell{
            
            cell.titleLbl.text = testArray3[indexPath.row].title
            cell.contentLbl.text = testArray3[indexPath.row].content
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


