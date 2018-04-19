//
//  IntroVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/3/29.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var intros = [IntroItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intros = [IntroItem(thumbImage: #imageLiteral(resourceName: "logo_white"), title: "PUBG LIKE RULES", description: "Have Fun Mate!"),
                  IntroItem(thumbImage: #imageLiteral(resourceName: "logo_white"), title: "PUBG LIKE RULES", description: "Have Fun Mate!"),
                  IntroItem(thumbImage: #imageLiteral(resourceName: "logo_white"), title: "PUBG LIKE RULES", description: "Have Fun Mate!"),
                  IntroItem(thumbImage: #imageLiteral(resourceName: "logo_white"), title: "PUBG LIKE RULES", description: "Have Fun Mate!")]
        
        pageControl.numberOfPages = intros.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width / 1.05)
    }
}

extension IntroVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as? IntroCell{
            
            cell.thumbImage.image = intros[indexPath.row].thumbImage
            cell.title.text = intros[indexPath.row].title
            cell.correspondDescription.text = intros[indexPath.row].description
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.size.width - 10, height: 524)
    }
}
