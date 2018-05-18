//
//  FriendListVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FriendListVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.performSegue(withIdentifier: "toSearchVC", sender: nil)
        
        searchBar.endEditing(true)
        searchBar.reloadInputViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchVC"{
            _ = segue.destination as! SearchVC
        }
    }
}
