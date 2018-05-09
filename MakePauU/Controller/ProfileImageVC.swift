//
//  ProfileImageVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/11.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class ProfileImageVC: UIViewController {

    @IBOutlet weak var imageView: CustomImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.image = image
        
        setDismiss()
    }
    
    func setDismiss(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
}
