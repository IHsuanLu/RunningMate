//
//  ContentViewCell.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/22.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

//可以把delegate給VC(checkoutVC) 這裡不轉交直接在cell做
class ContentViewCell: UICollectionViewCell{
    
    @IBOutlet weak var rankCollection: UICollectionView!
    
    var sections: [RankSection] = [
        RankSection(section: "次數王", thumbImage: [], title: [], info: []),
        RankSection(section: "里程王", thumbImage: [], title: [], info: []),
        RankSection(section: "最速王", thumbImage: [], title: [], info: [])
    ]
    
    
    var countItems: [RankItem]!
    var distanceItems: [RankItem]!
    var timeItems: [RankItem]!
    
    lazy var setRankingThing: () = {
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self)
        
        sections = [
            RankSection(section: "次數王", thumbImage: [], title: [], info: []),
            RankSection(section: "里程王", thumbImage: [], title: [], info: []),
            RankSection(section: "最速王", thumbImage: [], title: [], info: [])
        ]
        
        FirebaseService.shared().getRankingInfo(completion: { (countItems, ifcontent) in
            self.countItems = countItems
            
            if ifcontent == false {
                // add View
                let label = UILabel()
                label.textColor = UIColor(netHex: 0x666666)
                label.text = "目前尚無資料！"
                label.font = UIFont(name: "Helvetica Neue", size: 17)
                label.frame = CGRect(x: self.frame.width / 2 - 60, y: 40, width: 200, height: 30)
                self.addSubview(label)
            }
        })
        
        FirebaseService.shared().getRankingInfo_Dis(completion: { (distanceItems, ifcontent) in
            self.distanceItems = distanceItems
            
            if ifcontent == false {
                // add View
                let label = UILabel()
                label.textColor = UIColor(netHex: 0x666666)
                label.text = "目前尚無資料！"
                label.font = UIFont.boldSystemFont(ofSize: 17)
                label.frame = CGRect(x: self.frame.width / 2 - 60, y: 20, width: 200, height: 30)
                self.addSubview(label)
            }
            
            FirebaseService.shared().getRankingInfo_Time(completion: { (timeItems, ifcontent) in
                self.timeItems = timeItems
                self.updateUI()
                print(self.timeItems!)
                
                if ifcontent == false {
                    // add View
                    let label = UILabel()
                    label.textColor = UIColor(netHex: 0x666666)
                    label.text = "目前尚無資料！"
                    label.font = UIFont.boldSystemFont(ofSize: 17)
                    label.frame = CGRect(x: self.frame.width / 2 - 60, y: 20, width: 200, height: 30)
                    self.addSubview(label)
                }
                
                SetLoadingScreen.sharedInstance.stopActivityIndicator()
            })
        })

    }()
    
    override func layoutSubviews() {
        _ = setRankingThing
    }
    
    func updateUI(){
        
        if let countItems = self.countItems, let distanceItems = self.distanceItems, let timeItems = self.timeItems {
            
            for count in countItems {
                sections[0].title.append(count.name)
                sections[0].info.append("\(count.value!) 場")
                sections[0].thumbImage.append(count.proflieImage)
            }
            for dis in distanceItems {
                sections[1].title.append(dis.name)
                sections[1].info.append("\(dis.value!) 公里")
                sections[1].thumbImage.append(dis.proflieImage)
            }
            for time in timeItems {
                sections[2].title.append(time.name)
                sections[2].thumbImage.append(time.proflieImage)
                
                let timeText = "\(Int(Double(truncating: time.value!) / 60))'\(Int(round(Double(truncating: time.value!).truncatingRemainder(dividingBy: 60))))''"
                sections[2].info.append(timeText)
            }
            
            self.rankCollection.delegate = self
            self.rankCollection.dataSource = self
        }
    }
}

extension ContentViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[collectionView.tag].thumbImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCell", for: indexPath) as? RankCell{
            
            var medalArray: [UIImage] = [#imageLiteral(resourceName: "gold-medal"),#imageLiteral(resourceName: "silver-medal"),#imageLiteral(resourceName: "bronze-medal")]
            for _ in 0...sections[collectionView.tag].thumbImage.count - 3{
                medalArray.append(UIImage())
            }

            cell.metalImageView.image = medalArray[indexPath.row]
            
            let thumbImages = self.sections[collectionView.tag].thumbImage
            let thumbImage = thumbImages[indexPath.row]
            cell.thumbImageView.image = thumbImage
            
            let titles = self.sections[collectionView.tag].title
            let title = titles[indexPath.row]
            cell.nameLbl.text = title
            
            let infos = self.sections[collectionView.tag].info
            let info = infos[indexPath.row]
            cell.infoLbl.text = info
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
