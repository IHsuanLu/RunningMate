//
//  FinalConfirmVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/11.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FinalConfirmVC: UIViewController {

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var items = [RoomMemberItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = [
            RoomMemberItem(thumbImage: #imageLiteral(resourceName: "pic1"), title: "死亡少女"),
            RoomMemberItem(thumbImage: #imageLiteral(resourceName: "pic2"), title: "尼好毒"),
            RoomMemberItem(thumbImage: #imageLiteral(resourceName: "pic3"), title: "我剛剛跨完年")
        ]
        
        FirebaseService.sharedInstance.setFinalConfirm(completion: { (estimate_distance) in
            self.distanceLbl.text = String(format: "%.2f", estimate_distance)
            
            let seconds = estimate_distance * 450
            self.timeLbl.text = "\(Int(Double(seconds / 60)))'\(Int(round(Double(seconds.truncatingRemainder(dividingBy: 60)))))''"
        })
        
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        StartStatus.sharedInstance.ifEntered = true
    }
    
    @IBAction func denyBtnPressed(_ sender: Any) {
        StartStatus.sharedInstance.ifEntered = false
    }
} 

extension FinalConfirmVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomMemberCell", for: indexPath) as! RoomMemberCell
        
        cell.thumbImageView.image = items[indexPath.row].thumbImage
        cell.titleLbl.text = items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}


