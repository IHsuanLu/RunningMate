//
//  SearchVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/18.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
