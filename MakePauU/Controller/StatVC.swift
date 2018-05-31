//
//  StatVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/31.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class StatVC: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentViewHeight.constant = 700
        
        addNumbers()
        addLabels()
        addShapeLayer()
    }
    
    func addNumbers(){
        
        let label1 = UILabel()
        label1.frame = CGRect(x: contentView.frame.width / 2 - 75, y: contentViewHeight.constant / 4 - 55, width: 150, height: 50)
        label1.text = "本次跑步距離"
        label1.textColor = UIColor(netHex: 0x666666)
        label1.font = UIFont.boldSystemFont(ofSize: 24)
        label1.textAlignment = .center
        contentView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: contentView.frame.width / 2 - 75, y: contentViewHeight.constant / 2 - 20, width: 150, height: 50)
        label2.text = "本次跑步時間"
        label2.textColor = UIColor(netHex: 0x666666)
        label2.font = UIFont.boldSystemFont(ofSize: 24)
        label2.textAlignment = .center
        contentView.addSubview(label2)

        
        let label3 = UILabel()
        label3.frame = CGRect(x: contentView.frame.width / 2 - 75, y: (contentViewHeight.constant * 3) / 4 + 20, width: 150, height: 35)
        label3.text = "本次平均速率"
        label3.textColor = UIColor(netHex: 0x666666)
        label3.font = UIFont.boldSystemFont(ofSize: 24)
        label3.textAlignment = .center
        contentView.addSubview(label3)
    }
    
    func addLabels(){
        
        let label1 = UILabel()
        label1.frame = CGRect(x: contentView.frame.width / 2 - 58, y: contentViewHeight.constant / 4 - 10, width: 120, height: 25)
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
        label3.text = "本次平均速率"
        label3.textColor = UIColor(netHex: 0x999999)
        label3.font = UIFont.boldSystemFont(ofSize: 12)
        label3.textAlignment = .center
        contentView.addSubview(label3)
    }
    
    func addShapeLayer(){
        
        let shapeLayer1 = CAShapeLayer()
        let center1 = CGPoint(x: contentView.frame.width / 2, y: contentViewHeight.constant / 4 - 35)
        setShapeLayer(shapeLayer: shapeLayer1, center: center1)
        animateCircle(shapeLayer: shapeLayer1)
        
        let shapeLayer2 = CAShapeLayer()
        let center2 = CGPoint(x: contentView.frame.width / 2, y: contentViewHeight.constant / 2)
        setShapeLayer(shapeLayer: shapeLayer2, center: center2)
        animateCircle(shapeLayer: shapeLayer2)

        let shapeLayer3 = CAShapeLayer()
        let center3 = CGPoint(x: contentView.frame.width / 2, y: (contentViewHeight.constant * 3) / 4 + 35)
        setShapeLayer(shapeLayer: shapeLayer3, center: center3)
        animateCircle(shapeLayer: shapeLayer3)
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
    
    func animateCircle(shapeLayer: CAShapeLayer){
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.8
        //停住
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "total_time")
    }
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
