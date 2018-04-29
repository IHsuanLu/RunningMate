//
//  UserVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/29.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    @IBOutlet weak var imageCollection: UICollectionView!
    
    var testArray: [UserImageItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testArray = [
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1")),
            UserImageItem(image: #imageLiteral(resourceName: "user1"))
        ]
    }
}

extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as! UserImageCell
        cell.thumbImageView.image = testArray[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == imageCollection {
            return CGSize(width: collectionView.frame.size.width, height: self.view.frame.size.height * 375)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


