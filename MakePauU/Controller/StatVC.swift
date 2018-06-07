//
//  StatVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/31.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class StatVC: UIViewController {

    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var total_distance: Double!
    var average_time: Double!
    var total_time: Double!
    
    var friendListVC = FriendListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmBtn.setTitleColor(UIColor.white, for: .selected)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        SetLoadingScreen.sharedInstance.startActivityIndicator(view: self.view)
        
        FirebaseService.shared().getLatestStat { (total_distance, average_time, total_time) in
            
            self.confirmBtn.reloadInputViews()
            
            self.total_distance = total_distance
            self.average_time = average_time
            self.total_time = total_time
            self.addNumbers()
            
            SetLoadingScreen.sharedInstance.stopActivityIndicator()
            
            self.addLabels()
            self.addShapeLayer()
            
            self.view.reloadInputViews()
        }

        contentViewHeight.constant = 700
        
        self.view.reloadInputViews()
    }
    
    func addNumbers(){
        
        let label1 = UILabel()
        label1.frame = CGRect(x: contentView.frame.width / 2 - 75, y: contentViewHeight.constant / 4 - 65, width: 150, height: 50)
        label1.text = "\(total_distance!)"
        label1.textColor = UIColor(netHex: 0x666666)
        label1.font = UIFont.boldSystemFont(ofSize: 32)
        label1.textAlignment = .center
        contentView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: contentView.frame.width / 2 - 75, y: contentViewHeight.constant / 2 - 20, width: 150, height: 50)
        label2.text = "\(Int(Double(total_time / 60)))'\(Int(round(Double(total_time.truncatingRemainder(dividingBy: 60)))))''"
        label2.textColor = UIColor(netHex: 0x666666)
        label2.font = UIFont.boldSystemFont(ofSize: 32)
        label2.textAlignment = .center
        contentView.addSubview(label2)

        
        let label3 = UILabel()
        label3.frame = CGRect(x: contentView.frame.width / 2 - 75, y: (contentViewHeight.constant * 3) / 4 + 20, width: 150, height: 35)
        label3.text = "\(Int(Double(average_time / 60)))'\(Int(round(Double(average_time.truncatingRemainder(dividingBy: 60)))))''"
        label3.textColor = UIColor(netHex: 0x666666)
        label3.font = UIFont.boldSystemFont(ofSize: 32)
        label3.textAlignment = .center
        contentView.addSubview(label3)
    }
    
    func addLabels(){
        
        let label = UILabel()
        label.frame = CGRect(x: contentView.frame.width - 218, y: 8, width: 210, height: 25)
        label.text = "註：百分比為與本局其他玩家之比較"
        label.textColor = UIColor(netHex: 0x999999)
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        contentView.addSubview(label)
        
        let label1 = UILabel()
        label1.frame = CGRect(x: contentView.frame.width / 2 - 58, y: contentViewHeight.constant / 4 - 20, width: 120, height: 25)
        label1.text = "本次跑步距離 (km)"
        label1.textColor = UIColor(netHex: 0x999999)
        label1.font = UIFont.boldSystemFont(ofSize: 12)
        label1.textAlignment = .center
        contentView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: contentView.frame.width / 2 - 58, y: contentViewHeight.constant / 2 + 25, width: 120, height: 25)
        label2.text = "本次跑步時間"
        label2.textColor = UIColor(netHex: 0x999999)
        label2.font = UIFont.boldSystemFont(ofSize: 12)
        label2.textAlignment = .center
        contentView.addSubview(label2)
        
        
        let label3 = UILabel()
        label3.frame = CGRect(x: contentView.frame.width / 2 - 58, y: (contentViewHeight.constant * 3) / 4 + 55, width: 120, height: 25)
        label3.text = "本次平均時間"
        label3.textColor = UIColor(netHex: 0x999999)
        label3.font = UIFont.boldSystemFont(ofSize: 12)
        label3.textAlignment = .center
        contentView.addSubview(label3)
    }
    
    func addShapeLayer(){
        
        let shapeLayer1 = CAShapeLayer()
        let center1 = CGPoint(x: contentView.frame.width / 2, y: contentViewHeight.constant / 4 - 35)
        setShapeLayer(shapeLayer: shapeLayer1, center: center1)
        animateCircle(shapeLayer: shapeLayer1, toValue: 0.3)
        
        let shapeLayer2 = CAShapeLayer()
        let center2 = CGPoint(x: contentView.frame.width / 2, y: contentViewHeight.constant / 2)
        setShapeLayer(shapeLayer: shapeLayer2, center: center2)
        animateCircle(shapeLayer: shapeLayer2, toValue: 0.7)

        let shapeLayer3 = CAShapeLayer()
        let center3 = CGPoint(x: contentView.frame.width / 2, y: (contentViewHeight.constant * 3) / 4 + 35)
        setShapeLayer(shapeLayer: shapeLayer3, center: center3)
        animateCircle(shapeLayer: shapeLayer3, toValue: 0.5)
    }
    
    func setShapeLayer(shapeLayer: CAShapeLayer, center: CGPoint){
        
        //track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor(netHex: 0xf5f5f5).cgColor
        trackLayer.lineWidth = 8
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        
        contentView.layer.addSublayer(trackLayer)
        
        //needs path
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor(netHex: 0xE9A11A).cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        
        //prepare for animation
        shapeLayer.strokeEnd = 0
        
        contentView.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle(shapeLayer: CAShapeLayer, toValue: Double){
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = toValue
        basicAnimation.duration = 1.8
        //停住
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "total_time")
    }
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        FavoriteFriendIDs.sharedInstance.favoriteFriends = []
        EnterRoomStatus.sharedInstance.ifEnteredRoom = false
        GameStatus.sharedInstance.ifStarted = false
        StartStatus.sharedInstance.ifEntered = false
        
        FirebaseService.destroy()
        
        print(FavoriteFriendIDs.sharedInstance.favoriteFriends)
        print(EnterRoomStatus.sharedInstance.ifEnteredRoom)
        print(GameStatus.sharedInstance.ifStarted)
        print(StartStatus.sharedInstance.ifEntered)
        
        dismiss(animated: true, completion: nil)
    }
    
}
