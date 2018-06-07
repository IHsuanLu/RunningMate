//
//  AirdropVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/6.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class AirdropVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var expandBtn: UIButton!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var ifExpanded = true
    
    var titles: [String] = []
    var QRcodes: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: tableView)
        
        FirebaseService.shared().getAirdrops { (titles, QRcodes) in
            self.titles = titles
            self.QRcodes = QRcodes
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
            
            self.tableView.tableFooterView = UIView()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func expandBtnPressed(_ sender: Any) {
        
        ifExpanded = !ifExpanded
        
        if !ifExpanded {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.collectionViewHeight.constant = 0
                self.expandBtn.setTitle("Show", for: .normal)
                self.expandBtn.frame = CGRect(x: 0, y: 26, width: 85, height: 24)
                self.collectionView.frame = CGRect(x: 0, y: 26, width: 0, height: 0)
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.collectionViewHeight.constant = self.view.frame.height * 0.45
                self.expandBtn.setTitle("Hide", for: .normal)
                self.expandBtn.frame = CGRect(x: 0, y: self.view.frame.height * 0.45 + 26, width: 85, height: 24)
                self.collectionView.frame = CGRect(x: 0, y: 26, width: self.view.frame.width, height: self.view.frame.height * 0.45)

                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toQRCodeVC"{
            if let destination = segue.destination as? QRCodeVC {
                destination.airdropDetail = sender as! AirdropDetail
            }
        }
    }
}

extension AirdropVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirdropRecCell", for: indexPath) as! AirdropRecCell
        
        var imageArray = [#imageLiteral(resourceName: "nike_price"), #imageLiteral(resourceName: "adidas_price"), #imageLiteral(resourceName: "protein_price")]
        var titleArray = ["Nike Epic React Flyknit", "Adidas 束口袋", "Whey Protein 5磅"]
        
        cell.airdropImageView.image = imageArray[indexPath.item]
        cell.titleLbl.text = titleArray[indexPath.item]
        
        return cell
    }
}

extension AirdropVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirdropCell", for: indexPath) as! AirdropCell
        
        cell.titleLbl.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let airdropDetail = AirdropDetail(title: titles[indexPath.row], QRcode: QRcodes[indexPath.row])
        performSegue(withIdentifier: "toQRCodeVC", sender: airdropDetail)
    }
}
