//
//  PreloadVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/18.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class PreloadVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ApiService.sharedInstance.checkSession { (ifLogged) in
            
            print(ifLogged)
            
            if ifLogged {
                
                self.performSegue(withIdentifier: "initToFirstPageVC", sender: nil)
            } else {
                
                self.performSegue(withIdentifier: "initToIntroVC", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "initToIntroVC"{
            _ = segue.destination as! IntroVC
        }
        
        
        if segue.identifier == "initToFirstPageVC"{
            
            if let barViewControllers = segue.destination as? UITabBarController{
                if let nav =  barViewControllers.viewControllers![0] as? UINavigationController {
                    if let _ = nav.topViewController as? FirstPageVC {
                    
                    }
                }
            }
        }
    }
}
