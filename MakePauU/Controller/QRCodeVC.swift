//
//  QRCodeVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/6.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import AudioToolbox

class QRCodeVC: UIViewController {
    
    @IBOutlet weak var QRcodeImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sponserLbl: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var airdropDetail: AirdropDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI(){
        
        if let airdropDetail = self.airdropDetail {
            
            titleLbl.text = airdropDetail.title
            QRcodeImageView.image = airdropDetail.QRcode
        }
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "確定兌換？", message: "提醒：一旦確定，兌換券將立即失效。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.confirmBtn.backgroundColor = UIColor(netHex: 0x999999)
            self.confirmBtn.isEnabled = false
            self.confirmBtn.setTitle("已兌換", for: .normal)
            
            // send request
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
