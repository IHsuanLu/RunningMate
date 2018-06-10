//
//  FinalConfirmVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/11.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FinalConfirmVC: UIViewController {

    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countdownLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var ifEntered: Bool = false
    
    var items = [RoomMemberItem]()
    
    var startGameTimer = Timer()
    var startGameCount = 10.0
    
    var checkStatusTimer = Timer()
    
    var reloadTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self.view)
        
        //timer 撈
        setTimer_reloadUI()

        
        tableView.separatorStyle = .none
    }
    
    func setTimer_reloadUI(){
        
        reloadTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startRoloading), userInfo: nil, repeats: true)
    }
    
    func setTimer_StartGame(){
        
        startGameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCounting), userInfo: nil, repeats: true)
    }
    
    func setTimer_CheckRoomStatus(){
        
        checkStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(startChecking), userInfo: nil, repeats: true)
    }
    
    @objc func startRoloading(){
        
        FirebaseService.shared().setFinalConfirm(completion: { (estimate_distance, member_items) in
            
            print("?????????????????????\(member_items.count)")
            
            self.distanceLbl.text = String(format: "%.2f", estimate_distance)
            
            let seconds = estimate_distance * 450
            self.timeLbl.text = "\(Int(Double(seconds / 60)))'\(Int(round(Double(seconds.truncatingRemainder(dividingBy: 60)))))''"
            
            self.items = member_items
            
            self.tableView.reloadData()
            
            if self.startGameCount == 10.0 {
                self.setTimer_StartGame()
            }
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
        })
    }
    
    @objc func startCounting(){
        
        startGameCount = startGameCount - 1.0
        countdownLbl.text = "(\(Int(startGameCount)))"
        
        if startGameCount == 0.0 {
            startGameTimer.invalidate()
            
            if ifEntered == true {
                    
                StartStatus.sharedInstance.ifEntered = true //for startgameVC 判斷
                EnterRoomStatus.sharedInstance.ifEnteredRoom = true
                    
                //每兩秒撈房間狀態
                self.setTimer_CheckRoomStatus()
                
            } else {
                    
                StartStatus.sharedInstance.ifEntered = false
                EnterRoomStatus.sharedInstance.ifEnteredRoom = false
                    
                ApiService.sharedInstance.start_game_cancel {
                    print("start_game_cancel")
                }
        
                performSegue(withIdentifier: "unwindFromFinalConfirm", sender: nil)
            }
        }
    }
    
    @objc func startChecking(){
        
        FirebaseService.shared().checkRoomStatus { (ifNormal) in
            
            if ifNormal == true {
                self.reloadTimer.invalidate()
                self.checkStatusTimer.invalidate()
                self.warningLbl.isHidden = true
                self.performSegue(withIdentifier: "unwindFromFinalConfirm", sender: nil)
            } else {
                self.warningLbl.isHidden = false
                print("不正常，等待中")
            }
        }
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        ifEntered = true
        
        confirmBtn.setTitle("等待進入遊戲。。", for: .normal)
        confirmBtn.backgroundColor = UIColor(netHex: 0x666666)
        confirmBtn.isEnabled = false
    }
    
    @IBAction func denyBtnPressed(_ sender: Any) {
        
        //不正常中離開
        if self.checkStatusTimer.isValid == true {
            self.checkStatusTimer.invalidate()
        }
        
        ApiService.sharedInstance.start_game_cancel {
            print("start_game_cancel")
        }
        print(MemberId.sharedInstance.member_id) 
        
        StartStatus.sharedInstance.ifEntered = false
        EnterRoomStatus.sharedInstance.ifEnteredRoom = false
        
        performSegue(withIdentifier: "unwindFromFinalConfirm", sender: nil)
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


