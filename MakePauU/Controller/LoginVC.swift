//
//  LoginVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 8.0
    }
    
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
