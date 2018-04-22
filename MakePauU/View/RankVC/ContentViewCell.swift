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
    var testArray: [RankItem]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankCollection.delegate = self
        rankCollection.dataSource = self
        
        testArray = [
            RankItem(section: "成就王", thumbImage: [#imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic3")], title: ["我剛剛跨完年", "東尼塔克", "NCCU U", "尼好毒", "Cory豪", "哈尼阿仁", "餅乾人好冷", "烤肉John", "光輝上將", "堅毅中校"], info: ["21 場", "18 場", "17 場", "15 場", "13 場", "13 場", "12 場", "9 場", "7 場", "2 場", ]),
            RankItem(section: "里程王", thumbImage: [#imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic3")], title: ["堅毅中校", "光輝上將", "烤肉John", "餅乾人好冷", "哈尼阿仁", "Cory豪", "尼好毒", "NCCU U", "東尼塔克", "我剛剛跨完年"], info: ["2 場", "7 場", "9 場", "12 場", "13 場", "13 場", "15 場", "17 場", "18 場", "21 場", ]),
            RankItem(section: "冠軍王", thumbImage: [#imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic3")], title: ["我剛剛跨完年", "東尼塔克", "NCCU U", "尼好毒", "Cory豪", "哈尼阿仁", "餅乾人好冷", "烤肉John", "光輝上將", "堅毅中校"], info: ["1 場", "1 場", "1 場", "1 場", "1 場", "1 場", "1 場", "1 場", "1 場", "0 場", ])
        ]
    }
}

extension ContentViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray[collectionView.tag].thumbImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCell", for: indexPath) as? RankCell{
            
            var medalArray: [UIImage] = [#imageLiteral(resourceName: "gold-medal"),#imageLiteral(resourceName: "silver-medal"),#imageLiteral(resourceName: "bronze-medal")]
            for _ in 0...testArray[collectionView.tag].thumbImage.count - 3{
                medalArray.append(UIImage())
            }

            cell.metalImageView.image = medalArray[indexPath.row]
            
            let thumbImages = self.testArray[collectionView.tag].thumbImage
            let thumbImage = thumbImages[indexPath.row]
            cell.thumbImageView.image = thumbImage
            
            let titles = self.testArray[collectionView.tag].title
            let title = titles[indexPath.row]
            cell.nameLbl.text = title
            
            let infos = self.testArray[collectionView.tag].info
            let info = infos[indexPath.row]
            cell.infoLbl.text = info
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
