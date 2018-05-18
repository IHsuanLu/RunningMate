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
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self.view)
        
        FirebaseService.sharedInstance.setFinalConfirm(completion: { (estimate_distance, member_items) in
            
            print("?????????????????????\(member_items.count)")
            
            self.distanceLbl.text = String(format: "%.2f", estimate_distance)
            
            let seconds = estimate_distance * 450
            self.timeLbl.text = "\(Int(Double(seconds / 60)))'\(Int(round(Double(seconds.truncatingRemainder(dividingBy: 60)))))''"
            
            self.items = member_items
            
            self.tableView.reloadData()
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
        })
        
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        StartStatus.sharedInstance.ifEntered = true
    }
    
    @IBAction func denyBtnPressed(_ sender: Any) {
        
        ApiService.sharedInstance.start_game_cancel {
            print("Leave")
        }
        print(MemberId.sharedInstance.member_id)
        
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


