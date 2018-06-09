//
//  RankingVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/21.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class RankingVC: UIViewController {

    @IBOutlet weak var menuBarCollection: UICollectionView!
    @IBOutlet weak var contentViewCollection: UICollectionView!
    @IBOutlet weak var rankCollection: UICollectionView!
    @IBOutlet weak var horizontalBar: UIView!
    
    @IBOutlet weak var horizontalBarLeading: NSLayoutConstraint!
    
    var width: CGFloat!
    var horizontalBar_X: CGFloat!
    
    var countItems: [RankItem]!
    var distanceItems: [RankItem]!
    var timeItems: [RankItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.frame.size.width
        print(width)
        
        setPreSelectedItem()
        adjustConstraint()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == contentViewCollection{
            
            self.horizontalBarLeading.constant = scrollView.contentOffset.x / 3
            self.horizontalBar.frame = CGRect(x: scrollView.contentOffset.x / 3, y: self.horizontalBar.frame.origin.y, width: self.horizontalBar.frame.width, height: self.horizontalBar.frame.height)
        }
    }
    
    //know where the scrollView will end (讓item cell被選中)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //換頁
        if scrollView == contentViewCollection{
            let index = targetContentOffset.pointee.x / width
            let indexPath = IndexPath(item: Int(index), section: 0)
            
            menuBarCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func setPreSelectedItem(){
        let preSelectedIndexPath = IndexPath(row: 0, section: 0)
        menuBarCollection.selectItem(at: preSelectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func adjustConstraint(){
        
        for constraint in horizontalBar.constraints {
            if constraint.identifier == "horizontalBarWidth" {
                constraint.constant = width / 3
            }
        }
    }
}

extension RankingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == menuBarCollection{
            return 1
        } else if collectionView == contentViewCollection{
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuBarCollection{
            return 3
        } else if collectionView == contentViewCollection{
            return 3
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == menuBarCollection{
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCell", for: indexPath) as? MenuBarCell{
                
                let array = ["次數王", "里程王", "最速王"]
                cell.titleLbl.text = array[indexPath.row]
                
                return cell
            }
            
        } else if collectionView == contentViewCollection{
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentViewCell", for: indexPath) as? ContentViewCell{
                
                //differentiate by means of using tag
                cell.rankCollection.tag = indexPath.row

                        
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == menuBarCollection{
            return CGSize(width: width / 3, height: 36)
        } else if collectionView == contentViewCollection {
            return CGSize(width: width, height: self.contentViewCollection.frame.height)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuBarCollection {
            horizontalBar_X = CGFloat(indexPath.item) * (width / 3)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.horizontalBar.frame = CGRect(x: self.horizontalBar_X, y: self.horizontalBar.frame.origin.y, width: self.horizontalBar.frame.width, height: self.horizontalBar.frame.height)
                
                self.contentViewCollection.layoutIfNeeded()
            }, completion: nil)
            
            let newIndexPath = IndexPath(item: indexPath.item, section: 0)
            contentViewCollection.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}



