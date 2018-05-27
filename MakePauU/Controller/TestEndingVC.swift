//
//  TestEndingVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/2.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class TestEndingVC: UIViewController {

    var settingEnding = SettingEnding()
    var setting = Setting()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        setting.showSetting()
//        settingEnding.showSetting()
    }
}
